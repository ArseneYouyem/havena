// Nécessite que ClientsBinding et PrestatairesBinding soient aussi enregistrés
// sur la page (pour ClientsRepository et PrestatairesRepository, utilisés par
// FinancesController).
import 'package:get/get.dart';
import 'package:havena/core/database/app_database.dart';
import 'package:havena/core/references/reference_generator_service.dart';
import 'package:havena/features/auth/controllers/session_controller.dart';
import 'package:havena/features/clients/repositories/clients_repository.dart';
import 'package:havena/features/finances/controllers/finances_controller.dart';
import 'package:havena/features/finances/repositories/finances_repository.dart';
import 'package:havena/features/prestataires/repositories/prestataires_repository.dart';

class FinancesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FinancesRepository>(() => FinancesRepository(
          Get.find<AppDatabase>().financesDao,
          Get.find<ReferenceGeneratorService>(),
        ));
    Get.lazyPut<FinancesController>(() => FinancesController(
          Get.find<FinancesRepository>(),
          Get.find<ClientsRepository>(),
          Get.find<PrestatairesRepository>(),
          Get.find<SessionController>(),
        ));
  }
}
