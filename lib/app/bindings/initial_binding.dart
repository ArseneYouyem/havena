import 'package:get/get.dart';
import 'package:havena/app/controllers/navigation_controller.dart';
import 'package:havena/app/routes/app_routes.dart';
import 'package:havena/core/auth/role_permissions.dart';
import 'package:havena/core/database/app_database.dart';
import 'package:havena/core/references/reference_generator_service.dart';
import 'package:havena/core/storage/file_storage_service.dart';
import 'package:havena/core/storage/get_storage_service.dart';
import 'package:havena/features/auth/controllers/session_controller.dart';
import 'package:havena/features/auth/repositories/auth_repository.dart';
import 'package:havena/features/auth/services/auth_session_cache_service.dart';
import 'package:havena/features/auth/services/firebase_auth_service.dart';
import 'package:havena/features/auth/services/firestore_users_service.dart';
import 'package:havena/features/photos/repositories/photos_repository.dart';

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
    Get.put<ReferenceGeneratorService>(
      ReferenceGeneratorService(Get.find<AppDatabase>()),
      permanent: true,
    );
    Get.put<FileStorageService>(
      FileStorageService(),
      permanent: true,
    );
    Get.put<PhotosRepository>(
      PhotosRepository(
        Get.find<AppDatabase>().photosDao,
        Get.find<FileStorageService>(),
      ),
      permanent: true,
    );
    Get.put<NavigationController>(
      NavigationController(),
      permanent: true,
    );

    Get.put<FirebaseAuthService>(
      FirebaseAuthService(),
      permanent: true,
    );
    Get.put<FirestoreUsersService>(
      FirestoreUsersService(),
      permanent: true,
    );
    Get.put<AuthSessionCacheService>(
      AuthSessionCacheService(Get.find<GetStorageService>()),
      permanent: true,
    );
    Get.put<AuthRepository>(
      AuthRepository(
        firebaseAuthService: Get.find<FirebaseAuthService>(),
        firestoreUsersService: Get.find<FirestoreUsersService>(),
        authSessionCacheService: Get.find<AuthSessionCacheService>(),
      ),
      permanent: true,
    );
    Get.put<SessionController>(
      SessionController(),
      permanent: true,
    );

    final resumedSession = Get.find<AuthRepository>().tryResumeSession();
    if (resumedSession != null) {
      Get.find<SessionController>().setSession(resumedSession);
      final allowedRoutes = RolePermissions.routesFor(resumedSession.role);
      Get.find<NavigationController>().changeTo(
        allowedRoutes.isNotEmpty ? allowedRoutes.first : AppRoutes.dashboard,
      );
    }
  }
}
