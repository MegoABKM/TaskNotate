import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasknotate/bindings/initialbinding.dart';
import 'package:tasknotate/controller/theme_controller.dart';
import 'package:tasknotate/core/localization/changelocal.dart';
import 'package:tasknotate/core/localization/translation.dart';
import 'package:tasknotate/core/services/sound_service.dart';
import 'package:tasknotate/core/services/storage_service.dart';
import 'package:tasknotate/routes.dart';
import 'package:tasknotate/core/services/app_bootstrap_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Alarm.init(showDebugLogs: true);

  // Initialize StorageService
  final prefs = await SharedPreferences.getInstance();
  final storageService = StorageService(prefs: prefs);
  Get.put<StorageService>(storageService, permanent: true);
  print('[Main] StorageService initialized.');

  // Initialize ThemeController and LocalController
  Get.put<ThemeController>(ThemeController(), permanent: true);
  print('[Main] ThemeController put.');
  Get.put<LocalController>(LocalController(), permanent: true);
  print('[Main] LocalController put.');

  // Initialize SoundService
  await Get.putAsync<SoundService>(() async {
    final service = SoundService();
    await service.init();
    print('[Main] SoundService initialized and put.');
    return service;
  }, permanent: true);

  final prefsForRoute = storageService.sharedPreferences;

  final String determinedInitialRoute =
      await AppBootstrapService.determineInitialRoute(prefsForRoute);
  print('[Main] Determined initial route: $determinedInitialRoute');

  AppBootstrapService.setupNativeMethodCallHandler();
  print('[Main] Native method call handler setup.');

  await MyTranslation.init();
  print('[Main] Translations initialized.');

  runApp(MyApp(initialRoute: determinedInitialRoute));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (themeCtrl) => GetMaterialApp(
        translations: MyTranslation(),
        initialBinding: InitialBinding(),
        debugShowCheckedModeBanner: false,
        locale: Get.find<LocalController>().language,
        fallbackLocale: const Locale('en'),
        theme: themeCtrl.currentTheme,
        getPages: routes,
        initialRoute: initialRoute,
      ),
    );
  }
}
