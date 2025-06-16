import 'package:alarm/alarm.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController {
  var areAlarmsDisabled = false.obs;

  @override
  void onInit() {
    super.onInit();
    areAlarmsDisabled.value = false;
  }

  Future<void> toggleAllAlarms(bool disable) async {
    if (disable) {
      await Alarm.stopAll();
      areAlarmsDisabled.value = true;
      Get.snackbar(
        "key_alarms_disabled".tr,
        "key_all_alarms_disabled".tr,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 2),
      );
    } else {
      areAlarmsDisabled.value = false;
      Get.snackbar(
        "key_alarms_enabled".tr,
        "key_alarms_now_enabled".tr,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 2),
      );
    }
  }
}
