import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService extends GetxService {
  final SharedPreferences _sharedPreferences;

  StorageService({required SharedPreferences prefs})
      : _sharedPreferences = prefs;

  SharedPreferences get sharedPreferences => _sharedPreferences;

  Future<void> init() async {
    print("StorageService: Initialized.");
  }
}
