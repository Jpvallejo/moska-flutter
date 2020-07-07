import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:intl/intl.dart';
import 'package:moska_app/src/models/cc_expense_model.dart';
import 'package:moska_app/src/models/credit_card_view_model.dart';
import 'package:moska_app/src/services/credit_card_expense_service.dart';
import 'package:moska_app/src/utils/UnauthorizedException.dart';
import 'package:moska_app/src/utils/my_navigator.dart';

class CCExpensesScreen extends StatefulWidget {
  CCExpensesScreen({Key key}) : super(key: key);
  @override
  _CCExpensesScreenState createState() => new _CCExpensesScreenState();
}

class _CCExpensesScreenState extends State<CCExpensesScreen> {
  List<Dismissible> rows;
  List<CCExpenseModel> data;
  DateTime date = DateTime.now();
  double totalAmount = 0;
  final oCcy = new NumberFormat("#,##0.00", "en_US");
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final CreditCardViewModel args = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      key: _scaffoldKey,
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
                  // rows = snapshot.data.map((cc) => createCCRow(cc)).toList();
                  data = snapshot.data;
                  return ListView.builder(
                    
                    physics: NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            final item = data[index];
                            return createCCRow(item, snapshot.data, index);
                          });
                }
              }),
        ],
      )),
      bottomNavigationBar: BottomAppBar(
        child: FutureBuilder<double>(
          future: getCCExpensesSum(args.id, date.month, date.year),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return Text("loading");
            } else if (snapshot.hasError) {
              if (snapshot.error is UnauthorizedException) {
                MyNavigator.goToLogin(context);
              }
              return Text(snapshot.error.toString());
            } else {
              return Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text("Total: "),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(oCcy.format(snapshot.data)),
                  )
                ],
              );
            }
          },
        ),
        color: Colors.grey,
      ),
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

  Dismissible createCCRow(
      CCExpenseModel cc, List<CCExpenseModel> data, int index) {
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
        await deleteCCExpense(cc);
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
        leading: Icon(Icons.credit_card),
        title: Text(cc.description ?? ''),
        subtitle: Text(DateFormat('MM-dd-yyyy').format(cc.date) ?? ''),
        trailing: Text(cc.amount.toString()),
      ),
    );
  }

  displaySnackBar(BuildContext context) {
    final snackBar = SnackBar(content: Text('Item deleted'));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
