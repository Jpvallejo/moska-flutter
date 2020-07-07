import 'package:flutter/material.dart';
import 'package:moska_app/src/models/credit_card_view_model.dart';

class MyNavigator {
  static void goToHome(BuildContext context, {int selectedTab = 0}) {
    Navigator.pushNamed(context, "/home", arguments: selectedTab);
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

  static void goToCCExpenses(BuildContext context, CreditCardViewModel selectedCard) {
    Navigator.pushNamed(context, "/ccExpense", arguments: selectedCard);
  }
  static void goToCreateCCExpense(BuildContext context) {
    Navigator.pushNamed(context, "/ccExpense/create");
  }
  
  static void goToCreateExpense(BuildContext context) {
    Navigator.pushNamed(context, "/expense/create");
  }
  
  static void goToCreateIncome(BuildContext context) {
    Navigator.pushNamed(context, "/income/create");
  }

  static void goToAccounts(BuildContext context) {
    Navigator.pushNamed(context, "/accounts");
  }
}