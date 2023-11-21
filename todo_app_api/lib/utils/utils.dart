import 'package:flutter/material.dart';

class Utils {
  static Future<T> push<T>(BuildContext context, Widget child) {
    PageRoute route = MaterialPageRoute(
      builder: (context) => child,
    );
    return Navigator.of(context).push(route) as Future<T>;
  }

  static Future<T> pushAndRemoveUtil<T>(BuildContext context, Widget child) {
    PageRoute route = MaterialPageRoute(
      builder: (context) => child,
    );
    return Navigator.of(context).pushAndRemoveUntil(
        route, (Route<dynamic> route) => false) as Future<T>;
  }

  static Future<T> pop<T>(BuildContext context) {
    return Navigator.of(context).pop() as Future<T>;
  }
}