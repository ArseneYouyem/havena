import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:havena/app/bindings/initial_binding.dart';
import 'package:havena/app/routes/app_pages.dart';
import 'package:havena/app/routes/app_routes.dart';
import 'package:havena/app/theme/app_theme.dart';
import 'package:havena/core/storage/get_storage_service.dart';
import 'package:havena/features/auth/services/auth_session_cache_service.dart';
import 'package:havena/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await GetStorageService.init();

  // Résolution de session hors GetX : détermine la route de démarrage sans
  // appel réseau, avant que GetMaterialApp (et InitialBinding) ne soit monté.
  final hasLocalSession =
      AuthSessionCacheService(GetStorageService()).read() != null;
  final initialRoute = hasLocalSession ? AppRoutes.dashboard : AppRoutes.login;

  runApp(HavenApp(initialRoute: initialRoute));
}

class HavenApp extends StatelessWidget {
  const HavenApp({super.key, required this.initialRoute});

  final String initialRoute;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'HAVENA',
      theme: AppTheme.light,
      initialBinding: InitialBinding(),
      getPages: AppPages.routes,
      initialRoute: initialRoute,
      debugShowCheckedModeBanner: false,
    );
  }
}
