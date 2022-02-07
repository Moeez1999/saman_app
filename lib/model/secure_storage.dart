import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreference {
  FlutterSecureStorage _storage = FlutterSecureStorage();


  Future writeSecureData(String key, String value) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var writeData = await _prefs.setString(key,value);
    return writeData;
  }

  Future readSecureData(String key) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var readData = _prefs.getString(key);
    return readData;
  }

  Future deletedSecureData(String key) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var deletedSecureData = await _prefs.remove(key);
    return deletedSecureData;
  }

  Future deletedAllSecureData() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var deletedAllSecureData = await _prefs.clear();
    return deletedAllSecureData;
  }
}
