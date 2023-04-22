import 'package:wheel/src/biz/user/login_type.dart';

class AppLoginRequest {
  AppLoginRequest({
    required this.username,
    required this.password,
    required this.loginType,
    required this.loginUrl,
    this.nickname,
    this.avatarUrl,
  });

  String username;
  String password;
  String loginUrl;
  LoginType loginType;
  String? nickname;
  String? avatarUrl;

  Map<String, dynamic> toMap() {
    return {
      "username": username,
      "password": password,
      "loginUrl": loginUrl,
      "loginType": loginType.index,
      "nickname": nickname,
      "avatarUrl": avatarUrl,
    };
  }
}
