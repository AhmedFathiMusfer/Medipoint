import 'package:flutter/material.dart';

extension Navigations on BuildContext {
  Future<dynamic> pushNamed(String routeName, {Object? arguments}) {
    return Navigator.of(this).pushNamed(routeName, arguments: arguments);
  }

  Future<dynamic> pushReplacementNamed(String routeName, {Object? arguments}) {
    return Navigator.of(
      this,
    ).pushReplacementNamed(routeName, arguments: arguments);
  }

  Future<dynamic> pushNamedAndRemoveUntil(
    String routeName, {
    Object? arguments,
    required RoutePredicate predicate,
  }) {
    return Navigator.of(
      this,
      rootNavigator: true,
    ).pushNamedAndRemoveUntil(routeName, predicate, arguments: arguments);
  }

  void pop({bool? result}) => Navigator.of(this).pop(bool);
}
