import 'dart:convert';

class AppUser {
  AppUser({
    required this.phone,
    required this.registerTime,
    required this.nickName
  });

  String phone;
  String registerTime;
  String nickName;

  factory AppUser.fromJson(String str) => AppUser.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());


  factory AppUser.fromMap(Map<String, dynamic> json) => AppUser(
    phone: json["phone"] == null ? null : json["phone"],
    registerTime: json["registerTime"] == null ? null : json["registerTime"],
    nickName: json["nickName"] == null ? null : json["nickName"],
  );

  Map<String, dynamic> toMap() => {
    "phone": phone,
    "registerTime": registerTime,
    "nickName": nickName
  };
}