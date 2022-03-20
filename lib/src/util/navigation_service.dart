import 'package:flutter/material.dart';

class NavigationService {
  GlobalKey<NavigatorState> navigationKey = GlobalKey();

  static NavigationService instance = NavigationService();

  NavigationService() {
    navigationKey = GlobalKey<NavigatorState>();
  }

  Future<dynamic> navigateToReplacement(String _rn) {
    return navigationKey.currentState!.pushReplacementNamed(_rn);
  }

  static Future<void> navigateToReplacementUtil(String _rn) async {
    if (NavigationService.instance.navigationKey.currentState != null) {
      NavigationService.instance.navigationKey.currentState!.pushNamedAndRemoveUntil(_rn, ModalRoute.withName("/"));
    }
  }

  Future<dynamic> navigateTo(String _rn) {
    return navigationKey.currentState!.pushNamed(_rn);
  }

  Future<dynamic> navigateToRoute(MaterialPageRoute _rn) {
    return navigationKey.currentState!.push(_rn);
  }

  goback() {
    return navigationKey.currentState!.pop();
  }
}
