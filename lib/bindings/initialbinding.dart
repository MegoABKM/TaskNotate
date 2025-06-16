import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasknotate/controller/home_controller.dart';
import 'package:tasknotate/controller/theme_controller.dart';
import 'package:tasknotate/core/localization/changelocal.dart';
import 'package:tasknotate/core/services/alarm_display_service.dart';
import 'package:tasknotate/core/services/alarm_service.dart';
import 'package:tasknotate/core/services/app_security_service.dart';
import 'package:tasknotate/core/services/database_service.dart';
import 'package:tasknotate/core/services/notification_service.dart';
import 'package:tasknotate/core/services/sound_service.dart';
import 'package:tasknotate/core/services/storage_service.dart';
import 'package:tasknotate/core/services/supabase_service.dart';

class InitialBinding extends Bindings {
  @override
  Future<void> dependencies() async {
    print('InitialBinding: Starting async dependencies...');

    final prefs = await SharedPreferences.getInstance();
    final storageService = StorageService(prefs: prefs);
    Get.put<StorageService>(storageService, permanent: true);
    print('InitialBinding: StorageService initialized and put.');

    await Get.putAsync<SupabaseService>(() async {
      final service = SupabaseService();
      await service.init();
      print('InitialBinding: SupabaseService initialized and put.');
      return service;
    }, permanent: true);

    final appSecurityService = AppSecurityService();
    Get.put<AppSecurityService>(appSecurityService, permanent: true);
    print('InitialBinding: AppSecurityService initialized and put.');

    await Get.putAsync<ThemeController>(() async {
      final controller = ThemeController();
      print('InitialBinding: ThemeController initialized and put.');
      return controller;
    }, permanent: true);

    await Get.putAsync<LocalController>(() async {
      final controller = LocalController();
      print('InitialBinding: LocalController initialized and put.');
      return controller;
    }, permanent: true);

    await Get.putAsync<SoundService>(() async {
      final service = SoundService();
      await service.init();
      print('InitialBinding: SoundService initialized and put.');
      return service;
    }, permanent: true);

    await Get.putAsync<AlarmDisplayStateService>(
      () => AlarmDisplayStateService().initService(),
      permanent: true,
    );
    print('InitialBinding: AlarmDisplayStateService initialized and put.');

    await Get.putAsync<DatabaseService>(() async {
      final service = DatabaseService();
      await service.init();
      print('InitialBinding: DatabaseService initialized and put.');
      return service;
    }, permanent: true);

    await Get.putAsync<AlarmService>(() async {
      final service = AlarmService();
      await service.init();
      print('InitialBinding: AlarmService initialized and put.');
      return service;
    }, permanent: true);

    await Get.putAsync<NotificationService>(() async {
      final service = NotificationService();
      await service.init();
      await service.scheduleDailyNotifications(isTesting: false);
      print('InitialBinding: NotificationService initialized and put.');
      return service;
    }, permanent: true);

    // HomeController is already permanent: true
    Get.put<HomeController>(HomeController(), permanent: true);
    print('InitialBinding: HomeController put (permanent).');
    print('InitialBinding: All async dependencies completed.');
  }
}
