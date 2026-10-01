import 'dart:async';
import 'package:get/get.dart';
import 'package:havena/core/database/app_database.dart';
import 'package:havena/core/database/enums.dart';
import 'package:havena/features/abonnements/repositories/abonnements_repository.dart';
import 'package:havena/features/clients/repositories/clients_repository.dart';
import 'package:havena/features/finances/repositories/finances_repository.dart';
import 'package:havena/features/inspections/repositories/inspections_repository.dart';
import 'package:havena/features/interventions/repositories/interventions_repository.dart';
import 'package:havena/features/logements/repositories/logements_repository.dart';
import 'package:havena/features/prestataires/repositories/prestataires_repository.dart';

enum DashboardAlertLevel { rouge, orange, jaune }

class DashboardAlert {
  const DashboardAlert({required this.level, required this.message});

  final DashboardAlertLevel level;
  final String message;
}

class DashboardController extends GetxController {
  DashboardController(
    this._clientsRepository,
    this._logementsRepository,
    this._interventionsRepository,
    this._abonnementsRepository,
    this._financesRepository,
    this._prestatairesRepository,
    this._inspectionsRepository,
  );

  final ClientsRepository _clientsRepository;
  final LogementsRepository _logementsRepository;
  final InterventionsRepository _interventionsRepository;
  final AbonnementsRepository _abonnementsRepository;
  final FinancesRepository _financesRepository;
  final PrestatairesRepository _prestatairesRepository;
  final InspectionsRepository _inspectionsRepository;

  // Liste exacte demandée par le client (docs/temp.md, « Onglet 1 —
  // Tableau de bord »), plus quelques indicateurs complémentaires ajoutés
  // au-delà de cette liste (marge, prestataires actifs, satisfaction —
  // conservés, ne contredisent rien de la demande).
  final clientsActifs = 0.obs;
  final logementsCount = 0.obs;
  final abonnementsActifs = 0.obs;
  final abonnementsARenouveler = 0.obs;
  final inspectionsAEffectuer = 0.obs;
  final interventionsOuvertes = 0.obs;
  final interventionsTerminees = 0.obs;
  final paiementsEnAttente = 0.obs;
  final chiffreAffairesMensuel = 0.0.obs;
  final depensesMensuelles = 0.0.obs;
  final montantPayePrestataires = 0.0.obs;

  final margeMensuelle = 0.0.obs;
  final prestatairesActifs = 0.obs;
  final inspectionsRealisees = 0.obs;
  final incidentsOuverts = 0.obs;
  final satisfactionMoyenne = Rxn<double>();
  final alerts = <DashboardAlert>[].obs;

  /// Bascule vers l'écran « Procédures internes » (cahier des charges §15)
  /// — même principe liste/détail que les autres modules riches.
  final showProcedure = false.obs;
  void openProcedure() => showProcedure.value = true;
  void closeProcedure() => showProcedure.value = false;

  static const _interventionTerminees = {
    InterventionStatus.termine,
    InterventionStatus.paye,
    InterventionStatus.archive,
  };

  List<Abonnement> _lastAbonnements = [];
  List<Intervention> _lastInterventions = [];

  StreamSubscription? _clientsSub;
  StreamSubscription? _logementsSub;
  StreamSubscription? _interventionsSub;
  StreamSubscription? _abonnementsSub;
  StreamSubscription? _financesSub;
  StreamSubscription? _prestatairesSub;
  StreamSubscription? _inspectionsSub;

  @override
  void onInit() {
    super.onInit();
    _clientsSub = _clientsRepository.watchAll().listen((list) {
      clientsActifs.value =
          list.where((c) => c.status == ClientStatus.actif).length;
    });
    _logementsSub = _logementsRepository.watchAll().listen((list) {
      logementsCount.value = list.length;
    });
    _interventionsSub = _interventionsRepository.watchAll().listen((list) {
      _lastInterventions = list;
      interventionsOuvertes.value = list
          .where((i) => !_interventionTerminees.contains(i.status))
          .length;
      interventionsTerminees.value = list
          .where((i) => _interventionTerminees.contains(i.status))
          .length;
      incidentsOuverts.value = list
          .where((i) =>
              i.urgencyLevel == UrgencyLevel.critique &&
              !_interventionTerminees.contains(i.status))
          .length;
      final margeCeMois = list.where((i) {
        final date = i.interventionDate;
        final marge = i.havenaMargin;
        if (date == null || marge == null) return false;
        final now = DateTime.now();
        return date.year == now.year && date.month == now.month;
      }).fold<double>(0, (sum, i) => sum + i.havenaMargin!);
      margeMensuelle.value = margeCeMois;
      final notes =
          list.map((i) => i.clientSatisfaction).whereType<int>().toList();
      satisfactionMoyenne.value = notes.isEmpty
          ? null
          : notes.reduce((a, b) => a + b) / notes.length;
      _recomputeAlerts();
    });
    _abonnementsSub = _abonnementsRepository.watchAll().listen((list) {
      _lastAbonnements = list;
      abonnementsActifs.value = list.length;
      paiementsEnAttente.value = list
          .where((a) => a.paymentStatus != PaymentStatus.aJour)
          .length;

      final now = DateTime.now();
      final soon = now.add(const Duration(days: 7));
      abonnementsARenouveler.value = list.where((a) {
        final renewalSoon =
            a.renewalDate != null && a.renewalDate!.isBefore(soon);
        final paymentSoon =
            a.nextPaymentDate != null && a.nextPaymentDate!.isBefore(soon);
        return renewalSoon || paymentSoon;
      }).length;

      _recomputeAlerts();
    });
    _financesSub = _financesRepository.watchAll().listen((list) {
      final now = DateTime.now();
      final currentPeriod =
          '${now.year}-${now.month.toString().padLeft(2, '0')}';
      final monthTransactions = list.where((f) =>
          f.status != TransactionStatus.annule &&
          f.periodMonth == currentPeriod);

      chiffreAffairesMensuel.value = monthTransactions
          .where((f) => f.transactionType == TransactionType.entree)
          .fold<double>(0, (sum, f) => sum + f.amount);

      final sorties =
          monthTransactions.where((f) => f.transactionType == TransactionType.sortie);
      depensesMensuelles.value =
          sorties.fold<double>(0, (sum, f) => sum + f.amount);
      montantPayePrestataires.value = sorties
          .where((f) => f.relatedPrestataireId != null)
          .fold<double>(0, (sum, f) => sum + f.amount);
    });
    _prestatairesSub = _prestatairesRepository.watchAll().listen((list) {
      prestatairesActifs.value =
          list.where((p) => p.status == PrestataireStatus.actif).length;
    });
    _inspectionsSub = _inspectionsRepository.watchAll().listen((list) {
      inspectionsRealisees.value = list.where((i) => i.isValidated).length;
      // « Inspections à effectuer » (docs/temp.md) : inspections déjà
      // créées mais pas encore validées — `Abonnements.nextInspectionDate`
      // n'est jamais renseigné actuellement (champ prévu pour plus tard,
      // voir CLAUDE.md), une échéance calendaire ne serait donc jamais
      // fonctionnelle en l'état.
      inspectionsAEffectuer.value =
          list.where((i) => !i.isValidated).length;
    });
  }

  /// Regroupe en alertes couleur (Rouge/Orange/Jaune, docs/temp.md — Rouge
  /// « retard/urgent », Orange « action nécessaire », Jaune « à
  /// surveiller ») les situations qui demandent l'attention de la
  /// Fondatrice : abonnements impayés/en retard/à renouveler bientôt (même
  /// seuil de 7 jours que `AbonnementsController.isRenewalOrPaymentSoon`)
  /// et interventions non résolues classées urgence haute ou critique.
  /// Recalculée à chaque changement d'Abonnements ou d'Interventions (les
  /// deux sources d'alerte), pas de flux dédié pour rester simple.
  void _recomputeAlerts() {
    final impayes = _lastAbonnements
        .where((a) => a.paymentStatus == PaymentStatus.impaye)
        .length;
    final enRetard = _lastAbonnements
        .where((a) => a.paymentStatus == PaymentStatus.enRetard)
        .length;
    final now = DateTime.now();
    final soon = now.add(const Duration(days: 7));
    final renouvellementsProches = _lastAbonnements.where((a) {
      if (a.paymentStatus == PaymentStatus.impaye ||
          a.paymentStatus == PaymentStatus.enRetard) {
        return false;
      }
      final renewalSoon =
          a.renewalDate != null && a.renewalDate!.isBefore(soon);
      final paymentSoon =
          a.nextPaymentDate != null && a.nextPaymentDate!.isBefore(soon);
      return renewalSoon || paymentSoon;
    }).length;
    final interventionsCritiques = _lastInterventions
        .where((i) =>
            i.urgencyLevel == UrgencyLevel.critique &&
            !_interventionTerminees.contains(i.status))
        .length;
    final interventionsHaute = _lastInterventions
        .where((i) =>
            i.urgencyLevel == UrgencyLevel.haute &&
            !_interventionTerminees.contains(i.status))
        .length;

    final next = <DashboardAlert>[];
    if (impayes > 0) {
      next.add(DashboardAlert(
        level: DashboardAlertLevel.rouge,
        message: '$impayes abonnement(s) impayé(s)',
      ));
    }
    if (interventionsCritiques > 0) {
      next.add(DashboardAlert(
        level: DashboardAlertLevel.rouge,
        message: '$interventionsCritiques intervention(s) critique(s) non résolue(s)',
      ));
    }
    if (enRetard > 0) {
      next.add(DashboardAlert(
        level: DashboardAlertLevel.orange,
        message: '$enRetard abonnement(s) en retard de paiement',
      ));
    }
    if (interventionsHaute > 0) {
      next.add(DashboardAlert(
        level: DashboardAlertLevel.orange,
        message: '$interventionsHaute intervention(s) urgence haute non résolue(s)',
      ));
    }
    if (renouvellementsProches > 0) {
      next.add(DashboardAlert(
        level: DashboardAlertLevel.jaune,
        message: '$renouvellementsProches renouvellement(s)/paiement(s) sous 7 jours',
      ));
    }
    alerts.value = next;
  }

  @override
  void onClose() {
    _clientsSub?.cancel();
    _logementsSub?.cancel();
    _interventionsSub?.cancel();
    _abonnementsSub?.cancel();
    _financesSub?.cancel();
    _prestatairesSub?.cancel();
    _inspectionsSub?.cancel();
    super.onClose();
  }
}
