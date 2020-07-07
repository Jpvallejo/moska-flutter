import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moska_app/src/utils/my_navigator.dart';

class ModalFit extends StatelessWidget {
  final ScrollController scrollController;

  const ModalFit({Key key, this.scrollController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        child: SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: Text('Income'),
            leading: Icon(Icons.monetization_on, color: Colors.green,),
            onTap: () => MyNavigator.goToCreateIncome(context),
          ),
          ListTile(
            title: Text('Expense'),
            leading: Icon(Icons.attach_money, color: Colors.red,),
            onTap: () => MyNavigator.goToCreateExpense(context),
          ),
          ListTile(
            title: Text('Credit Card Expense'),
            leading: Icon(Icons.credit_card, color: Colors.blue),
            onTap: () => MyNavigator.goToCreateCCExpense(context),
          ),
          ListTile(
            title: Text('Credit Card Expense'),
            leading: Icon(Icons.account_balance_wallet, color: Colors.blue),
            onTap: () => MyNavigator.goToCreateAccount(context),
          )
        ],
      ),
    ));
  }
}