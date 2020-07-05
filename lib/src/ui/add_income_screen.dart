import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:intl/intl.dart';
import 'package:moska_app/src/models/account_view_model.dart';
import 'package:moska_app/src/services/account_service.dart';
import 'package:moska_app/src/services/income_service.dart';
import 'package:moska_app/src/utils/UnauthorizedException.dart';
import 'package:moska_app/src/utils/datepicker.dart';
import 'package:moska_app/src/utils/my_navigator.dart';

class AddIncomeScreen extends StatefulWidget {
  AddIncomeScreen({Key key}) : super(key: key);
  @override
  _AddIncomeScreenState createState() => new _AddIncomeScreenState();
}

class _AddIncomeScreenState extends State<AddIncomeScreen> {
  MoneyMaskedTextController amountController =
      MoneyMaskedTextController(decimalSeparator: ',', thousandSeparator: '.');
  TextEditingController descriptionController = new TextEditingController();
  DateTime date = DateTime.now();
  DatePicker datePicker;
  String selectedAccount;

  Future<List<AccountViewModel>> accountsFuture;

  @override
  void initState() {
    super.initState();

    // assign this variable your Future
    accountsFuture = getAccounts().catchError((error) =>
        {if (error is UnauthorizedException) MyNavigator.goToLogin(context)});
  }

  @override
  Widget build(BuildContext context) {
    datePicker = new DatePicker(context, onDateTimeChanged: handleDatePicker);

    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Income'),
        actions: <Widget>[
          new IconButton(
              icon: const Icon(Icons.save),
              onPressed: () {
                onSubmit();
              })
        ],
      ),
      body: new Column(
        children: <Widget>[
          new ListTile(
            leading: const Icon(Icons.attach_money),
            title: new TextField(
                controller: amountController,
                decoration: new InputDecoration(
                  hintText: "Amount",
                )),
          ),
          new ListTile(
              leading: GestureDetector(
                onTap: () {
                  datePicker.show(date);
                },
                child: Icon(Icons.calendar_today),
              ),
              title: new GestureDetector(
                  onTap: () {
                    datePicker.show(date);
                  },
                  child: Text(
                    DateFormat('MM-dd-yyyy').format(date),
                  ))),
          new ListTile(
            leading: const Icon(Icons.description),
            title: new TextField(
              controller: descriptionController,
              decoration: new InputDecoration(
                hintText: "Description",
              ),
            ),
          ),
          new ListTile(
            leading: const Icon(Icons.credit_card),
            title: FutureBuilder<List<AccountViewModel>>(
                future: accountsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return Text("loading");
                  } else if (snapshot.hasError) {
                    if (snapshot.error is UnauthorizedException) {
                      MyNavigator.goToLogin(context);
                    }
                    return Text(snapshot.error.toString());
                  } else {
                    return DropdownButton<String>(
                        hint: Text("Account"),
                        value: selectedAccount,
                        onChanged: (newValue) {
                          setState(() {
                            selectedAccount = newValue;
                          });
                        },
                        items: snapshot.data
                            .map((cc) => DropdownMenuItem<String>(
                                  child: Text(cc.name),
                                  value: cc.id,
                                ))
                            .toList());
                  }
                }),
          ),
        ],
      ),
    );
  }

  handleDatePicker(newDate) {
    setState(() {
      date = newDate;
    });
  }

  onSubmit() {
    String description = descriptionController.text;
    double amount = amountController.numberValue;

    saveIncome(amount, "ARS", description, selectedAccount, date)
        .then((result) => {MyNavigator.goToHome(context)})
        .catchError((error) => {
              if (error is UnauthorizedException) MyNavigator.goToLogin(context)
            });
  }
}
