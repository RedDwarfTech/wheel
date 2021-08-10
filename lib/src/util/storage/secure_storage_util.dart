

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageUtil{

  static FlutterSecureStorage _preferences = FlutterSecureStorage();

  static Future<String?> getString (String key, {String defValue = ''}) {
    return _preferences.read(key:key) ;
  }

  static Future<void> putString(String key, String value) {
    return _preferences.write(key:key, value:value);
  }

  static Future<void> delString(String key) {
    return _preferences.delete(key:key);
  }
}


