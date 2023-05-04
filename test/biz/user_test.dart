import 'package:flutter_test/flutter_test.dart';
import 'package:wheel/src/biz/user/user_service.dart';
import 'package:wheel/wheel.dart';

void main() {
  test('user register', () {
    CommonUtils.initialApp(ConfigType.PRO)
        .whenComplete(() => {UserService.regUser(phone: "+15683761628", password: "123", verifyCode: '123456', appRegUrl: '')});
  });
}
