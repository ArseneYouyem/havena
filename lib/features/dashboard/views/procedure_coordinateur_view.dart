import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:havena/app/theme/app_colors.dart';
import 'package:havena/features/dashboard/controllers/dashboard_controller.dart';

class _ProcedureStep {
  const _ProcedureStep({
    required this.title,
    required this.howTo,
    required this.icon,
  });

  final String title;
  final String howTo;
  final IconData icon;
}

/// Les 15 étapes du cahier des charges §15 (mêmes libellés que
/// `ProcedureCoordinateurPdfGenerator`, pour rester cohérent avec le
/// document PDF déjà existant), chacune accompagnée d'une explication
/// concrète de la manière de la réaliser avec HAVENA.
const _steps = [
  _ProcedureStep(
    title: 'Identifier le client.',
    howTo:
        'Recherche transversale (topbar, en haut de n\'importe quel écran) pour retrouver un client existant par sa référence ou son nom — ou créer une nouvelle fiche depuis le module Clients.',
    icon: Icons.person_search_outlined,
  ),
  _ProcedureStep(
    title: 'Identifier le logement.',
    howTo:
        'Depuis la fiche client, ou directement dans le module Logements, retrouver ou créer le logement concerné, lié à ce client.',
    icon: Icons.home_work_outlined,
  ),
  _ProcedureStep(
    title: 'Enregistrer la demande.',
    howTo:
        'Module Interventions → « Nouvelle intervention » : choisir le logement (le client est déduit automatiquement) et décrire le problème signalé.',
    icon: Icons.note_add_outlined,
  ),
  _ProcedureStep(
    title: "Attribuer une référence d'intervention.",
    howTo:
        'Automatique — HAVENA génère la référence (HAV-INT-000001...) dès la création, aucune saisie manuelle n\'est nécessaire.',
    icon: Icons.tag_outlined,
  ),
  _ProcedureStep(
    title: "Évaluer l'urgence.",
    howTo:
        'Dans la fiche de l\'intervention, choisir le niveau d\'urgence : Basse, Normale, Haute ou Critique.',
    icon: Icons.speed_outlined,
  ),
  _ProcedureStep(
    title: 'Sélectionner le prestataire.',
    howTo:
        'Dans la fiche de l\'intervention, assigner un prestataire depuis la liste (module Prestataires) selon sa spécialité et sa disponibilité.',
    icon: Icons.engineering_outlined,
  ),
  _ProcedureStep(
    title: 'Obtenir le devis.',
    howTo: 'Renseigner le montant du devis directement dans la fiche de l\'intervention.',
    icon: Icons.request_quote_outlined,
  ),
  _ProcedureStep(
    title: 'Faire valider le client.',
    howTo:
        'Activer « Devis validé par le client » dans la fiche une fois l\'accord du client obtenu — verrou avant de lancer l\'intervention.',
    icon: Icons.verified_outlined,
  ),
  _ProcedureStep(
    title: "Planifier l'intervention.",
    howTo: 'Renseigner la date d\'intervention prévue dans la fiche.',
    icon: Icons.event_available_outlined,
  ),
  _ProcedureStep(
    title: "Suivre l'intervention.",
    howTo:
        'Faire évoluer le statut au fil de l\'avancement : Planifiée → En cours → Terminée, directement depuis la fiche.',
    icon: Icons.timeline_outlined,
  ),
  _ProcedureStep(
    title: 'Vérifier le résultat.',
    howTo:
        'Ajouter des photos avant/après depuis la fiche de l\'intervention (cliquer sur une photo l\'agrandit, avec navigation entre toutes les photos).',
    icon: Icons.fact_check_outlined,
  ),
  _ProcedureStep(
    title: 'Enregistrer le paiement.',
    howTo:
        'Module Finances → nouvelle transaction : montant, mode de paiement, lié au client et/ou au prestataire concerné.',
    icon: Icons.payments_outlined,
  ),
  _ProcedureStep(
    title: 'Mettre à jour le dossier.',
    howTo:
        'Renseigner les montants définitifs (client/prestataire — la marge HAVENA se calcule automatiquement) et passer le statut à Payée ou Archivée.',
    icon: Icons.folder_open_outlined,
  ),
  _ProcedureStep(
    title: 'Demander la satisfaction du client.',
    howTo: 'Noter la satisfaction (1 à 5 étoiles) directement dans la fiche de l\'intervention.',
    icon: Icons.star_outline,
  ),
  _ProcedureStep(
    title: 'Archiver les photos et documents.',
    howTo:
        'Les photos sont classées automatiquement par logement (stockage local + Google Drive). Les documents (facture, reçu, contrat...) se génèrent en un clic depuis le module Documents.',
    icon: Icons.archive_outlined,
  ),
];

class ProcedureCoordinateurView extends GetView<DashboardController> {
  const ProcedureCoordinateurView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 760),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  color: AppColors.textPrimary,
                  onPressed: controller.closeProcedure,
                ),
                const SizedBox(width: 4),
                const Expanded(
                  child: Text(
                    'Procédures internes',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.primary, Color(0xFF14532D)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                children: [
                  Icon(Icons.route_outlined, color: Colors.white, size: 28),
                  SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      'Ce qu\'il faut faire, étape par étape, dès qu\'un client contacte HAVENA — et comment le faire directement avec le logiciel.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        height: 1.4,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            for (var i = 0; i < _steps.length; i++)
              _StepTile(
                index: i + 1,
                isLast: i == _steps.length - 1,
                step: _steps[i],
              ),
          ],
        ),
      ),
    );
  }
}

class _StepTile extends StatelessWidget {
  const _StepTile({
    required this.index,
    required this.isLast,
    required this.step,
  });

  final int index;
  final bool isLast;
  final _ProcedureStep step;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  '$index',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    color: AppColors.primary.withValues(alpha: 0.25),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: AppColors.secondarySurface,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(step.icon,
                              size: 16, color: AppColors.secondaryText),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            step.title,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      step.howTo,
                      style: const TextStyle(
                        fontSize: 13,
                        height: 1.5,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
