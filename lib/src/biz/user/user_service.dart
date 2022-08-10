import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../wheel.dart';

class UserService {
  static Future<AuthResult> regUser({required String phone, required String password, required String verifyCode}) async {
    Map body = {"phone": phone, "password": password, "verifyCode": verifyCode, "goto": 'news', "app": GlobalConfig.getConfig("appId")};
    final response = await RestClient.postHttp("/post/user/reg", body);
    if (RestClient.respSuccess(response)) {
      final storage = new FlutterSecureStorage();
      await storage.write(key: "username", value: phone);
      await storage.write(key: "password", value: password);
      return AuthResult(message: "register success", result: Result.ok);
    } else {
      return AuthResult(message: "user register failed", result: Result.error);
    }
  }
}
