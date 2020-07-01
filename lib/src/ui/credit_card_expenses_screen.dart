import 'package:flutter/material.dart';
import 'package:moska_app/src/models/cc_expense_model.dart';
import 'package:moska_app/src/services/credit_card_expense_service.dart';
import 'package:moska_app/src/utils/UnauthorizedException.dart';
import 'package:moska_app/src/utils/my_navigator.dart';

class CCExpensesScreen extends StatefulWidget {
  CCExpensesScreen({Key key}) : super(key: key);
  @override
  _CCExpensesScreenState createState() => new _CCExpensesScreenState();
}

class _CCExpensesScreenState extends State<CCExpensesScreen> {
  List<ListTile> rows;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: FutureBuilder<List<CCExpenseModel>>(
            future: getCreditCardExpenses("-MBBGDVYlG3VRdvbbsm4"),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return Text("loading");
              } else if (snapshot.hasError) {
                if(snapshot.error is UnauthorizedException) {
                  MyNavigator.goToLogin(context);
                }
                return Text(snapshot.error.toString());
              } else {
                rows = snapshot.data
                    .map((cc) => ListTile(
                          leading: Icon(Icons.credit_card),
                          title: Text(cc.description ?? ''),
                          trailing: Text(cc.amount.toString()),
                        ))
                    .toList();
                return Column(children: rows);
              }
            }),
    )
    );
  }
}
