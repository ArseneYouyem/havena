import 'dart:async';
import 'package:get/get.dart';
import 'package:havena/core/database/enums.dart';
import 'package:havena/features/abonnements/repositories/abonnements_repository.dart';
import 'package:havena/features/clients/repositories/clients_repository.dart';
import 'package:havena/features/interventions/repositories/interventions_repository.dart';
import 'package:havena/features/logements/repositories/logements_repository.dart';

class DashboardController extends GetxController {
  DashboardController(
    this._clientsRepository,
    this._logementsRepository,
    this._interventionsRepository,
    this._abonnementsRepository,
  );

  final ClientsRepository _clientsRepository;
  final LogementsRepository _logementsRepository;
  final InterventionsRepository _interventionsRepository;
  final AbonnementsRepository _abonnementsRepository;

  final clientsCount = 0.obs;
  final logementsCount = 0.obs;
  final interventionsEnCours = 0.obs;
  final abonnementsActifs = 0.obs;

  static const _interventionTerminees = {
    InterventionStatus.termine,
    InterventionStatus.paye,
    InterventionStatus.archive,
  };

  StreamSubscription? _clientsSub;
  StreamSubscription? _logementsSub;
  StreamSubscription? _interventionsSub;
  StreamSubscription? _abonnementsSub;

  @override
  void onInit() {
    super.onInit();
    _clientsSub = _clientsRepository.watchAll().listen((list) {
      clientsCount.value = list.length;
    });
    _logementsSub = _logementsRepository.watchAll().listen((list) {
      logementsCount.value = list.length;
    });
    _interventionsSub = _interventionsRepository.watchAll().listen((list) {
      interventionsEnCours.value = list
          .where((i) => !_interventionTerminees.contains(i.status))
          .length;
    });
    _abonnementsSub = _abonnementsRepository.watchAll().listen((list) {
      abonnementsActifs.value = list.length;
    });
  }

  @override
  void onClose() {
    _clientsSub?.cancel();
    _logementsSub?.cancel();
    _interventionsSub?.cancel();
    _abonnementsSub?.cancel();
    super.onClose();
  }
}
