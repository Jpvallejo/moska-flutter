import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moska_app/src/models/expense_model.dart';
import 'package:moska_app/src/models/income_model.dart';
import 'package:moska_app/src/models/transaction_model.dart';
import 'package:moska_app/src/services/credit_card_expense_service.dart';
import 'package:moska_app/src/services/expense_service.dart';
import 'package:moska_app/src/services/income_service.dart';
import 'package:moska_app/src/services/transactions_service.dart';
import 'package:moska_app/src/utils/UnauthorizedException.dart';
import 'package:moska_app/src/utils/my_navigator.dart';

class TransactionsScreen extends StatefulWidget {
  TransactionsScreen({Key key}) : super(key: key);
  @override
  _TransactionsScreenState createState() => new _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  List<Dismissible> rows;
  List<TransactionModel> data;
  DateTime date = DateTime.now();
  double totalAmount = 0;
  final oCcy = new NumberFormat("#,##0.00", "en_US");
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
          FutureBuilder<List<TransactionModel>>(
              future: getTransactions(date.month, date.year),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return Column();
                } else if (snapshot.hasError) {
                  if (snapshot.error is UnauthorizedException) {
                    MyNavigator.goToLogin(context);
                  }
                  return Text(snapshot.error.toString());
                } else {
                  // rows = snapshot.data.map((cc) => createCCRow(cc)).toList();
                  data = snapshot.data;
                  return ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        final item = data[index];
                        return createRow(item, snapshot.data, index);
                      });
                }
              }),
        ],
      )),
    );
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

  Dismissible createRow(
      TransactionModel cc, List<TransactionModel> data, int index) {
    return Dismissible(
      // Each Dismissible must contain a Key. Keys allow Flutter to
      // uniquely identify widgets.
      key: Key(cc.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (DismissDirection direction) async {
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: const Text("Confirm"),
              content: const Text("Are you sure you wish to delete this item?"),
              actions: <Widget>[
                FlatButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text("Cancel",
                        style: TextStyle(color: Colors.red))),
                FlatButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text(
                    "Yes",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            );
          },
        );
      },
      // Provide a function that tells the app
      // what to do after an item has been swiped away.
      onDismissed: (direction) async {
        // Remove the item from the data source.
        await deleteTransaction(cc);
        setState(() {
          data.removeAt(index);
        });

        // Then show a snackbar.
        displaySnackBar(context);
      },
      // Show a red background as the item is swiped away.
      background: Container(
          color: Colors.red,
          child: Padding(
              padding: EdgeInsets.all(15.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "Delete",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.end,
                ),
              ))),
      child: ListTile(
        leading: getIcon(cc),
        title: Text(cc.description ?? ''),
        trailing: Text(cc.amount.toString()),
      ),
    );
  }

  displaySnackBar(BuildContext context) {
    final snackBar = SnackBar(content: Text('Item deleted'));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  getIcon(TransactionModel transaction) {
    if (transaction is IncomeModel) {
      return Icon(
        Icons.monetization_on,
        color: Colors.green,
      );
    } else if (transaction is ExpenseModel) {
      return Icon(
        Icons.attach_money,
        color: Colors.red,
      );
    } else {
      return Icon(Icons.credit_card, color: Colors.blue);
    }
  }

  deleteTransaction(TransactionModel transaction) {
    if (transaction is IncomeModel) {
      return deleteIncome(transaction);
    } else if (transaction is ExpenseModel) {
      return deleteExpense(transaction);
    } else {
      return deleteCCExpense(transaction);
    }
  }
}
