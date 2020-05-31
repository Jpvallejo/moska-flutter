import 'package:flutter/material.dart';

class MyNavigator {
  static void goToHome(BuildContext context) {
    Navigator.pushNamed(context, "/home");
  }
  static void goToCreateCCExpense(BuildContext context) {
    Navigator.pushNamed(context, "/ccExpense/create");
  }

  static void goToLogin(BuildContext context) {
    Navigator.pushNamed(context, "/login");
  }
  static void goToProfile(BuildContext context) {
    Navigator.pushNamed(context, "/profile");
  }
}