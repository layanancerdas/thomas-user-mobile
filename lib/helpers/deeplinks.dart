import 'package:flutter/material.dart';
import 'package:tomas/screens/payment/payment.dart';

class Deeplinks {
  static void parseRoute(
      Uri uri, GlobalKey<NavigatorState> navigatorKey, bool isLogin) {
// 1
    if (uri.pathSegments.isEmpty) {
      !isLogin
          ? navigatorKey.currentState.pushReplacementNamed('/Sign')
          : navigatorKey.currentState.pushReplacementNamed('/Home');
      return;
    }

// 2
    // Handle navapp://deeplinks/details/#
    final path = uri.pathSegments[0];
    print(path);
// 4
    switch (path) {
      case 'payment_finish':
        navigatorKey.currentState.pushReplacement(MaterialPageRoute(
            builder: (_) => Payment(
                  mode: 'finish',
                  fromDeeplink: true,
                  // driverId: uri.pathSegments[1],
                  // token: uri.pathSegments[2],
                )));
        break;
    }
  }
}
