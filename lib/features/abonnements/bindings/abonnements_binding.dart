// Nécessite que ClientsBinding, LogementsBinding, FinancesBinding et
// CalendrierBinding soient aussi enregistrées sur la page (pour les
// repositories utilisés par AbonnementsController — résolution paresseuse,
// voir ClientsBinding) : la création d'un abonnement enregistre
// automatiquement le paiement dans Finances et l'évènement de renouvellement
// dans le Calendrier.
import 'package:get/get.dart';
import 'package:havena/core/database/app_database.dart';
import 'package:havena/core/references/reference_generator_service.dart';
import 'package:havena/features/abonnements/controllers/abonnements_controller.dart';
import 'package:havena/features/abonnements/repositories/abonnements_repository.dart';
import 'package:havena/features/auth/controllers/session_controller.dart';
import 'package:havena/features/calendrier/repositories/calendrier_repository.dart';
import 'package:havena/features/clients/repositories/clients_repository.dart';
import 'package:havena/features/finances/repositories/finances_repository.dart';
import 'package:havena/features/logements/repositories/logements_repository.dart';

class AbonnementsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AbonnementsRepository>(() => AbonnementsRepository(
          Get.find<AppDatabase>().abonnementsDao,
          Get.find<ReferenceGeneratorService>(),
          Get.find<ClientsRepository>(),
          Get.find<LogementsRepository>(),
        ));
    Get.lazyPut<AbonnementsController>(() => AbonnementsController(
          Get.find<AbonnementsRepository>(),
          Get.find<ClientsRepository>(),
          Get.find<LogementsRepository>(),
          Get.find<SessionController>(),
          Get.find<FinancesRepository>(),
          Get.find<CalendrierRepository>(),
        ));
  }
}
