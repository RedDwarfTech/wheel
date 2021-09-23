enum LoginType { PHONE, WECHAT, NETEASE }

extension ResponseStatusExtension on LoginType {
  static const statusCodes = {
    LoginType.PHONE: 1,
    LoginType.WECHAT: 2,
    LoginType.NETEASE: 4,
  };

  int get statusCode => statusCodes[this]!;
}
