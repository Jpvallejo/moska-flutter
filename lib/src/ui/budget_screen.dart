import 'package:flutter/material.dart';

class BudgetScreen extends StatefulWidget {
  BudgetScreen({Key key}) : super(key: key);
  @override
  _BudgetScreenState createState() => new _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("Budget Works!"),
    );
  }

}