import 'package:flutter/material.dart';
import 'package:moska_app/src/models/cc_expense_model.dart';
import 'package:moska_app/src/models/credit_card_model.dart';
import 'package:moska_app/src/services/credit_card_service.dart';
import 'package:moska_app/src/utils/UnauthorizedException.dart';
import 'package:moska_app/src/utils/my_navigator.dart';

class CreditCardsScreen extends StatefulWidget {
  CreditCardsScreen({Key key}) : super(key: key);
  @override
  _CreditCardsScreenState createState() => new _CreditCardsScreenState();
}

class _CreditCardsScreenState extends State<CreditCardsScreen> {
  List<ListTile> rows;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: FutureBuilder<List<CreditCard>>(
          future: getCreditCards(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return Text("loading");
            } else if (snapshot.hasError) {
              if (snapshot.error is UnauthorizedException) {
                MyNavigator.goToLogin(context);
              }
              return Text(snapshot.error.toString());
            } else {
              rows = snapshot.data
                  .map((cc) => ListTile(
                        leading: GestureDetector(
                          onTap: () {
                            MyNavigator.goToCCExpenses(context, cc);
                          },
                          child: Icon(Icons.calendar_today),
                        ),
                        title: GestureDetector(
                            onTap: () {
                              MyNavigator.goToCCExpenses(context, cc);
                            },
                            child: Text(cc.name)),
                      ))
                  .toList();
              return Column(children: rows);
            }
          }),
    ));
  }
}
