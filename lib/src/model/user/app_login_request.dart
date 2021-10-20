import 'package:flutter/cupertino.dart';
import 'package:wheel/src/biz/user/login_type.dart';

class AppLoginRequest {
  AppLoginRequest({
    required this.username,
    required this.password,
    required this.loginType,
    this.nickname,
    this.avatarUrl
  });

  String username;
  String password;
  LoginType loginType;
  String? nickname;
  String? avatarUrl;

  Map<String, dynamic> toMap() {
    return {
      "username": username,
      "password": password,
      "loginType": loginType.index,
      "nickname": nickname,
      "avatarUrl": avatarUrl
    };
  }
}
