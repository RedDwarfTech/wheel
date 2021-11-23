import 'dart:convert';

class AppUser {
  AppUser({
    required this.phone,
    required this.registerTime,
  });

  String? phone;
  String? registerTime;

  factory AppUser.fromJson(String str) => AppUser.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());


  factory AppUser.fromMap(Map<String, dynamic> json) => AppUser(
    phone: json["phone"] == null ? null : json["phone"],
    registerTime: json["registerTime"] == null ? null : json["registerTime"],
  );

  Map<String, dynamic> toMap() => {
    "phone": phone == null ? null : phone,
    "registerTime": registerTime == null ? null : registerTime,
  };
}