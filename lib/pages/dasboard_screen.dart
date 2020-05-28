import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:moska_app/utils/moska.dart';

class DashboardScreen extends StatefulWidget {
  DashboardScreen({Key key}) : super(key: key);
  @override
  _DashboardScreenState createState() => new _DashboardScreenState();
}
var _balanceAmountController = MoneyMaskedTextController(initialValue: 20000,decimalSeparator: ',', thousandSeparator: '.');

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          _top(),
        ],
      ),
    );
  }

}

_top() {
  return Container(
    padding: EdgeInsets.all(16.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              "Current Balance",
              style: TextStyle(fontSize: 14),
              textAlign: TextAlign.center
            ),
            Text(
              "\$ " + _balanceAmountController.text,
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold
              ),
              textAlign: TextAlign.center,
              )
          ],
        )
      ],
      ),
  );
}