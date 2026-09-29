import 'package:get/get.dart';
import 'package:havena/app/controllers/navigation_controller.dart';
import 'package:havena/core/database/app_database.dart';
import 'package:havena/core/storage/get_storage_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<GetStorageService>(
      GetStorageService(),
      permanent: true,
    );
    Get.put<AppDatabase>(
      AppDatabase(),
      permanent: true,
    );
    Get.put<NavigationController>(
      NavigationController(),
      permanent: true,
    );
  }
}
