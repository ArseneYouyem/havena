import 'package:get/get.dart';
import 'package:havena/core/database/app_database.dart';
import 'package:havena/core/references/reference_generator_service.dart';
import 'package:havena/features/auth/controllers/session_controller.dart';
import 'package:havena/features/interventions/repositories/interventions_repository.dart';
import 'package:havena/features/prestataires/controllers/prestataires_controller.dart';
import 'package:havena/features/prestataires/repositories/prestataires_repository.dart';

// Nécessite que InterventionsBinding soit également enregistrée sur la page
// (résolution paresseuse, voir ClientsBinding) : la note de satisfaction
// client et le nombre d'interventions effectuées sont calculés depuis
// InterventionsRepository.
class PrestatairesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PrestatairesRepository>(() => PrestatairesRepository(
          Get.find<AppDatabase>().prestatairesDao,
          Get.find<ReferenceGeneratorService>(),
        ));
    Get.lazyPut<PrestatairesController>(() => PrestatairesController(
          Get.find<PrestatairesRepository>(),
          Get.find<SessionController>(),
          Get.find<InterventionsRepository>(),
        ));
  }
}
