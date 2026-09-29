import 'package:get/get.dart';
import 'package:havena/features/abonnements/repositories/abonnements_repository.dart';
import 'package:havena/features/clients/repositories/clients_repository.dart';
import 'package:havena/features/documents/controllers/documents_controller.dart';
import 'package:havena/features/finances/repositories/finances_repository.dart';
import 'package:havena/features/inspections/repositories/inspection_items_repository.dart';
import 'package:havena/features/inspections/repositories/inspections_repository.dart';
import 'package:havena/features/interventions/repositories/interventions_repository.dart';
import 'package:havena/features/logements/repositories/logements_repository.dart';
import 'package:havena/features/prestataires/repositories/prestataires_repository.dart';

/// Ne crée aucun repository : réutilise ceux déjà enregistrés par les
/// bindings des autres modules métier (doit donc être déclarée après eux
/// dans `AppPages`).
class DocumentsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DocumentsController>(() => DocumentsController(
          clientsRepository: Get.find<ClientsRepository>(),
          logementsRepository: Get.find<LogementsRepository>(),
          interventionsRepository: Get.find<InterventionsRepository>(),
          prestatairesRepository: Get.find<PrestatairesRepository>(),
          abonnementsRepository: Get.find<AbonnementsRepository>(),
          financesRepository: Get.find<FinancesRepository>(),
          inspectionsRepository: Get.find<InspectionsRepository>(),
          inspectionItemsRepository: Get.find<InspectionItemsRepository>(),
        ));
  }
}
