import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:havena/app/bindings/initial_binding.dart';
import 'package:havena/app/routes/app_pages.dart';
import 'package:havena/app/routes/app_routes.dart';
import 'package:havena/app/theme/app_theme.dart';
import 'package:havena/core/storage/get_storage_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorageService.init();
  runApp(const HavenApp());
}

class HavenApp extends StatelessWidget {
  const HavenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'HAVENA',
      theme: AppTheme.light,
      initialBinding: InitialBinding(),
      getPages: AppPages.routes,
      initialRoute: AppRoutes.dashboard,
      debugShowCheckedModeBanner: false,
    );
  }
}
