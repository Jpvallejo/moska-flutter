import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moska_app/src/models/cc_expense_model.dart';
import 'package:moska_app/src/models/credit_card_model.dart';
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
  DateTime date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final CreditCard args = ModalRoute.of(context).settings.arguments;

    return Scaffold(
        appBar: new AppBar(
          title: new Text(args.name),
          actions: <Widget>[
            new IconButton(
              icon: Icon(CupertinoIcons.profile_circled),
              onPressed: () {
                MyNavigator.goToProfile(context);
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
            child: Column(
          children: <Widget>[
            ListTile(
              leading: IconButton(
                icon: new Icon(Icons.keyboard_arrow_left),
                onPressed: onDecreaseMonth,
              ),
              title: new Text(
                DateFormat(DateFormat.ABBR_MONTH).format(date),
                textAlign: TextAlign.center,
              ),
              trailing: IconButton(
                icon: new Icon(Icons.keyboard_arrow_right),
                onPressed: onIncreaseMonth,
              ),
            ),
            FutureBuilder<List<CCExpenseModel>>(
                future: getCreditCardExpenses(args.id, date.month, date.year),
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
                              leading: Icon(Icons.credit_card),
                              title: Text(cc.description ?? ''),
                              trailing: Text(cc.amount.toString()),
                            ))
                        .toList();
                    return Column(children: rows);
                  }
                }),
          ],
        )));
  }

  onDecreaseMonth() {
    setState(() {
      date = new DateTime(date.year, date.month - 1, 1);
    });
  }

  onIncreaseMonth() {
    setState(() {
      date = new DateTime(date.year, date.month + 1, 1);
    });
  }
}
