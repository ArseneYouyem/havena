import 'package:get/get.dart';
import 'package:havena/features/abonnements/repositories/abonnements_repository.dart';
import 'package:havena/features/clients/repositories/clients_repository.dart';
import 'package:havena/features/dashboard/controllers/dashboard_controller.dart';
import 'package:havena/features/interventions/repositories/interventions_repository.dart';
import 'package:havena/features/logements/repositories/logements_repository.dart';

/// `DashboardController` n'est construit qu'à la première résolution
/// (`Get.find`), déclenchée quand la vue tableau de bord s'affiche — donc
/// bien après que tous les bindings de la page se soient exécutés, même si
/// `DashboardBinding` est déclarée en premier dans `AppPages`. Nécessite
/// `AbonnementsBinding`/`InterventionsBinding` sur la même page.
class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(() => DashboardController(
          Get.find<ClientsRepository>(),
          Get.find<LogementsRepository>(),
          Get.find<InterventionsRepository>(),
          Get.find<AbonnementsRepository>(),
        ));
  }
}
