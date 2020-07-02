import 'package:flutter/material.dart';
import 'package:moska_app/src/models/credit_card_model.dart';

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

  static void goToCreditCards(BuildContext context) {
    Navigator.pushNamed(context, "/creditCards");
  }

  static void goToCCExpenses(BuildContext context, CreditCard selectedCard) {
    Navigator.pushNamed(context, "/ccExpense", arguments: selectedCard);
  }
}