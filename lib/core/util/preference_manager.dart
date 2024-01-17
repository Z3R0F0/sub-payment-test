import 'package:cloudipsp_mobile_example/dependencyinjection/injection_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceManager {
  static void saveLastPurchaseToken(String lastPurchaseToken) {
    SharedPreferences preferences = serviceLocator<SharedPreferences>();
    preferences.setString("lastPurchaseToken", lastPurchaseToken);
  }

  static String? retrieveLastPurchaseToken() {
    SharedPreferences preferences = serviceLocator<SharedPreferences>();
    return preferences.getString("lastPurchaseToken");
  }

  static void setBottomSheetVisibility(bool isVisible) {
    SharedPreferences preferences = serviceLocator<SharedPreferences>();
    preferences.setBool("isBottomSheetVisible", isVisible);
  }

  static bool? isBottomSheetVisible() {
    SharedPreferences preferences = serviceLocator<SharedPreferences>();
    return preferences.getBool("isBottomSheetVisible");
  }

  static void saveUserAuthToken(String authToken) {
    SharedPreferences preferences = serviceLocator<SharedPreferences>();
    preferences.setString("userAuthToken", authToken);
  }

  static String? retrieveUserAuthToken() {
    SharedPreferences preferences = serviceLocator<SharedPreferences>();
    return preferences.getString("userAuthToken");
  }

  static void saveLanguagePreference(String languageCode) {
    SharedPreferences preferences = serviceLocator<SharedPreferences>();
    preferences.setString("languagePreference", languageCode);
  }

  static String? retrieveLanguagePreference() {
    SharedPreferences preferences = serviceLocator<SharedPreferences>();
    return preferences.getString("languagePreference");
  }

  static void clearPreferences() {
    SharedPreferences preferences = serviceLocator<SharedPreferences>();
    preferences.clear();
  }
}
