import 'package:get/get.dart';
import 'package:havena/core/storage/get_storage_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<GetStorageService>(
      GetStorageService(),
      permanent: true,
    );
  }
}
