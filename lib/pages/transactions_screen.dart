import 'package:flutter/material.dart';
import 'package:moska_app/utils/moska.dart';

class TransactionsScreen extends StatefulWidget {
  TransactionsScreen({Key key}) : super(key: key);
  @override
  _TransactionsScreenState createState() => new _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("Transactions Works!"),
    );
  }

}