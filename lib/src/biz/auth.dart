import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:wheel/src/biz/user/app_user.dart';
import 'package:wheel/src/biz/user/login_type.dart';
import 'package:wheel/src/model/user/app_login_request.dart';
import 'package:wheel/src/net/rest/response_status.dart';
import 'package:wheel/src/net/rest/result.dart';
import 'package:wheel/src/util/navigation_service.dart';
import 'package:wheel/wheel.dart' show CommonUtils, GlobalConfig, RestClient, SecureStorageUtil;

class AuthResult {
  String message;
  Result result;

  AuthResult({
    required this.message,
    required this.result,
  });
}

class Auth {
  final baseUrl = GlobalConfiguration().get("baseUrl");
  static RegExp validationRequired = RegExp(r"Validation required");

  static Future<bool> isLoggedIn() async {
    String? username = await SecureStorageUtil.getString("username");
    if (username == null) {
      return false;
    } else {
      return true;
    }
  }

  static Future<AppUser> currentUser() async {
    String? userName = await SecureStorageUtil.getString("username");
    String? registerTime = await SecureStorageUtil.getString("registerTime");
    AppUser user = new AppUser(phone: userName, registerTime: registerTime);
    return user;
  }

  static Future<AuthResult> vote({required String itemId}) async {
    Map body = {"id": itemId};
    final response = await RestClient.putHttp("/post/article/upvote", body);
    if (RestClient.respSuccess(response)) {
      return AuthResult(message: "SMS send success", result: Result.ok);
    } else {
      return AuthResult(message: "SMS send failed. Did you mistype your credentials?", result: Result.error);
    }
  }

  static Future<void> logout() async {
    await SecureStorageUtil.delString("username");
    await SecureStorageUtil.delString("password");
    await SecureStorageUtil.delString("registerTime");
    await SecureStorageUtil.delString("accessToken");
    await SecureStorageUtil.delString("freshToken");
  }

  static Future<AuthResult> sms({required String phone}) async {
    Map body = {"phone": phone};
    final response = await RestClient.postHttp("/post/user/sms", body);
    if (RestClient.respSuccess(response)) {
      final storage = new FlutterSecureStorage();
      await storage.write(key: "phone", value: phone);
      return AuthResult(message: "SMS send success", result: Result.ok);
    } else {
      return AuthResult(message: response.data["msg"], result: Result.error);
    }
  }

  static Future<AuthResult> setPwd({required String phone, required String password}) async {
    Map body = {
      "phone": phone,
      "password": password,
      "goto": 'news',
      "app": GlobalConfig.getConfig("appId")
    };
    final response = await RestClient.postHttp("/post/user/set/pwd", body);
    if (RestClient.respSuccess(response)) {
      final storage = new FlutterSecureStorage();
      await storage.write(key: "username", value: phone);
      await storage.write(key: "password", value: password);
      return AuthResult(message: "Login success", result: Result.ok);
    } else {
      return AuthResult(message: "Login failed. Did you mistype your credentials?", result: Result.error);
    }
  }

  static Future<AuthResult> verifyPhone({required String phone, required String verifyCode}) async {
    Map body = {
      "phone": phone,
      "verifyCode": verifyCode,
      "goto": 'news',
    };
    final response = await RestClient.postHttp("/post/user/verify", body);
    if (RestClient.respSuccess(response)) {
      final storage = new FlutterSecureStorage();
      await storage.write(key: "phone", value: phone);
      await storage.write(key: "verifyCode", value: verifyCode);
      return AuthResult(message: "Login success", result: Result.ok);
    } else {
      return AuthResult(message: "Login failed. Did you mistype your credentials?", result: Result.error);
    }
  }

  ///
  /// why do refresh token logic like this? why did not refresh the refresh token?
  /// why redirect to the login when refresh token invalid or expired?
  ///
  /// when refresh access token, the refresh token expire date will also refresh
  /// so we did not have the refresh token refresh logic
  /// where the refresh token expired or invalid, the user need to login again
  /// searching the refresh token refresh from internet and did not found any refresh token implement
  ///
  /// so the finally conclusion is:
  ///  do not refresh the refresh token
  ///  when refresh token invalid or expired, just redirect to the login page
  ///
  /// the login will popup when the user have a very long time did not use the app(according with the refresh token expired time period)
  ///
  ///
  static Future<AuthResult> refreshAccessToken({required String refreshToken}) async {
    /**
     * the snake case parameter was according the oauth 2.0 specification
     * https://www.oauth.com/oauth2-servers/access-tokens/refreshing-access-tokens/
      */
    Map body = {
      "grant_type": "refresh_token",
      "refresh_token": refreshToken,
    };
    final response = await RestClient.postAuthDio("/post/auth/access_token/refresh", body);
    if (RestClient.respSuccess(response)) {
      Map result = response.data["result"];
      String accessToken = result["accessToken"];
      SecureStorageUtil.putString("accessToken", accessToken);
      SecureStorageUtil.putString("accessToken", accessToken);
      return AuthResult(message: "ok", result: Result.ok);
    }  else {
      NavigationService.navigateToReplacementUtil("login");
      return AuthResult(message: "failed", result: Result.error);
    }
  }

  static Future<AuthResult> login({required AppLoginRequest appLoginRequest}) async {
    List<String> deviceInfo = await CommonUtils.getDeviceDetails();
    Map body = {
      "phone": appLoginRequest.username,
      "password": appLoginRequest.password,
      "goto": 'news',
      "loginType": appLoginRequest.loginType.statusCode,
      "deviceId": deviceInfo[2],
      "deviceName": deviceInfo[0],
      "deviceType": int.parse(deviceInfo[1]),
      "appId": GlobalConfig.getConfig("appId"),
      "nickname": appLoginRequest.nickname,
      "avatarUrl": appLoginRequest.avatarUrl
    };
    final response = await RestClient.postAuthDio("/post/user/login", body);
    if (RestClient.respSuccess(response)) {
      saveAuthInfo(response, appLoginRequest.username, appLoginRequest.password);
      return AuthResult(message: "Login success", result: Result.ok);
    } else {
      NavigationService.instance.navigateToReplacement("login");
      return AuthResult(message: "Login failed", result: Result.error);
    }
  }

  static void saveAuthInfo(Response response, String username, String password) {
    Map result = response.data["result"];
    String accessToken = result["accessToken"];
    String refreshToken = result["refreshToken"];
    String registerTime = result["registerTime"];
    SecureStorageUtil.putString("username", username);
    SecureStorageUtil.putString("password", password);
    SecureStorageUtil.putString("accessToken", accessToken);
    SecureStorageUtil.putString("refreshToken", refreshToken);
    SecureStorageUtil.putString("registerTime", registerTime);
  }


}
