import 'package:wheel/src/biz/user/login_type.dart';

class AppLoginRequest {
  AppLoginRequest({
    required this.username,
    required this.password,
    required this.loginType,
  });

  String username;
  String password;
  LoginType loginType;

  Map<String, dynamic> toMap() {
    return {
      "username": username,
      "password": password,
      "loginType": loginType.index
    };
  }
}
