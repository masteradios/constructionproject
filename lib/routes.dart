import 'package:flutter/material.dart';
import 'package:hiten/account/accountScreen.dart';
import 'package:hiten/admin/screens/AdminhomeScreen.dart';
import 'package:hiten/admin/screens/attendanceGraph.dart';
import 'package:hiten/screens/auth/auth.dart';

Route getRoute({required RouteSettings routeSettings}) {
  switch (routeSettings.name) {
    case AdminHomePage.routeName:
      return MaterialPageRoute(builder: (context) {
        return AdminHomePage();
      });
    case AttendancePage.routeName:
      return MaterialPageRoute(builder: (context) {
        return AttendancePage();
      });
    case LoginScreen.routeName:
      return MaterialPageRoute(builder: (context) {
        return LoginScreen();
      });
    case UserAccountScreen.routeName:
      return MaterialPageRoute(
          settings: routeSettings,
          builder: (context) {
            return UserAccountScreen();
          });
    default:
      return MaterialPageRoute(builder: (context) {
        return Scaffold(
          body: Center(
            child: Text('Route doesnt exist'),
          ),
        );
      });
  }
}
