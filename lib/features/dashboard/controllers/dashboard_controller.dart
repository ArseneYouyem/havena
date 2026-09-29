import 'dart:async';
import 'package:get/get.dart';
import 'package:havena/features/clients/repositories/clients_repository.dart';
import 'package:havena/features/logements/repositories/logements_repository.dart';

class DashboardController extends GetxController {
  DashboardController(this._clientsRepository, this._logementsRepository);

  final ClientsRepository _clientsRepository;
  final LogementsRepository _logementsRepository;

  final clientsCount = 0.obs;
  final logementsCount = 0.obs;
  final interventionsEnCours = 0.obs;
  final abonnementsActifs = 0.obs;

  StreamSubscription? _clientsSub;
  StreamSubscription? _logementsSub;

  @override
  void onInit() {
    super.onInit();
    _clientsSub = _clientsRepository.watchAll().listen((list) {
      clientsCount.value = list.length;
    });
    _logementsSub = _logementsRepository.watchAll().listen((list) {
      logementsCount.value = list.length;
    });
    // TODO: interventionsEnCours / abonnementsActifs une fois ces modules créés.
  }

  @override
  void onClose() {
    _clientsSub?.cancel();
    _logementsSub?.cancel();
    super.onClose();
  }
}
