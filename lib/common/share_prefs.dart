
import 'package:shared_preferences/shared_preferences.dart';

class SharePrefs {
  SharePrefs._();
  static late final SharedPreferences _sharedPreferences;
  static Future init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }
  
  static void setSwitchValue(bool value) {
    _sharedPreferences.setBool('switch', value);
  }

  static bool? getSwitchValue() {
    bool? value = _sharedPreferences.getBool('switch');
    return value;
  }
  static void setFirstTimePinningValue(bool value) {
    _sharedPreferences.setBool('pinWidget', value);
  }

  static bool? getFirstTimePiningSwitchValue() {
    bool? value = _sharedPreferences.getBool('pinWidget');
    return value;
  }
  static void setCategory(String cat) {
    _sharedPreferences.setString("Category", cat);
  }

  static void setMessage(List<String> message) {
    _sharedPreferences.setStringList("message", message);
    _sharedPreferences.reload();
  }

  static String getMessage() {
    return _sharedPreferences.getString("message")!;
  }
  
  
  static void setSliderValue(bool value) {
    _sharedPreferences.setBool('showonboard', value);
  }

  static bool? getSliderValue() {
   bool? value = _sharedPreferences.getBool('showonboard');
   if (value == null){
    return null;
   }
   else {
    return value;
   }
  }

  static void setListAya( String ayaList) {
    _sharedPreferences.setString("ayaList", ayaList);
    _sharedPreferences.reload();
  }
  
}