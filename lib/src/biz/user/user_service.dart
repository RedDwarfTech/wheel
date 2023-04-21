import 'package:dio/src/response.dart';

import '../../../wheel.dart';

class UserService {
  static Future<Response> regUser({required String phone, required String password, required String verifyCode, required String appRegUrl}) async {
    List<String> deviceInfo = await CommonUtils.getDeviceDetails();
    Map body = {
      "deviceId": deviceInfo[2],
      "deviceName": deviceInfo[0],
      "phone": phone,
      "password": password,
      "verifyCode": verifyCode,
      "goto": 'news',
      "app": GlobalConfig.getConfig("appId")
    };
    final response = await RestClient.postHttp(appRegUrl, body);
    if (RestClient.respSuccess(response)) {
      Auth.saveAuthInfo(response, phone);
    }
    return response;
  }
}
