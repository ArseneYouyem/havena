import 'package:get/get.dart';
import 'package:havena/app/controllers/reference_search_controller.dart';
import 'package:havena/features/abonnements/repositories/abonnements_repository.dart';
import 'package:havena/features/clients/repositories/clients_repository.dart';
import 'package:havena/features/finances/repositories/finances_repository.dart';
import 'package:havena/features/inspections/repositories/inspections_repository.dart';
import 'package:havena/features/interventions/repositories/interventions_repository.dart';
import 'package:havena/features/logements/repositories/logements_repository.dart';
import 'package:havena/features/prestataires/repositories/prestataires_repository.dart';
import 'package:havena/features/rapports/repositories/rapports_repository.dart';

/// Ne crée aucun repository : réutilise ceux déjà enregistrés par les
/// bindings des autres modules métier (doit donc être déclarée après eux
/// dans `AppPages`).
class ReferenceSearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReferenceSearchController>(() => ReferenceSearchController(
          clientsRepository: Get.find<ClientsRepository>(),
          logementsRepository: Get.find<LogementsRepository>(),
          abonnementsRepository: Get.find<AbonnementsRepository>(),
          interventionsRepository: Get.find<InterventionsRepository>(),
          prestatairesRepository: Get.find<PrestatairesRepository>(),
          financesRepository: Get.find<FinancesRepository>(),
          rapportsRepository: Get.find<RapportsRepository>(),
          inspectionsRepository: Get.find<InspectionsRepository>(),
        ));
  }
}
