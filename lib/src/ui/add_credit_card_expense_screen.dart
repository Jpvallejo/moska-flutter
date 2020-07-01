import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:intl/intl.dart';
import 'package:moska_app/src/models/credit_card_model.dart';
import 'package:moska_app/src/services/credit_card_expense_service.dart';
import 'package:moska_app/src/services/credit_card_service.dart';
import 'package:moska_app/src/utils/UnauthorizedException.dart';
import 'package:moska_app/src/utils/datepicker.dart';
import 'package:moska_app/src/utils/my_navigator.dart';

class AddCCExpenseScreen extends StatefulWidget {
  AddCCExpenseScreen({Key key}) : super(key: key);
  @override
  _AddCCExpenseScreenState createState() => new _AddCCExpenseScreenState();
}

class _AddCCExpenseScreenState extends State<AddCCExpenseScreen> {
  bool _withPayments = false;
  int numberOfPayments = 1;
  MoneyMaskedTextController amountController =
      MoneyMaskedTextController(decimalSeparator: ',', thousandSeparator: '.');
  MoneyMaskedTextController paymentAmountController =
      MoneyMaskedTextController(decimalSeparator: ',', thousandSeparator: '.');
  TextEditingController descriptionController = new TextEditingController();
  DateTime date = DateTime.now();
  DatePicker datePicker;
  String selectedCreditCard;

  @override
  Widget build(BuildContext context) {
    datePicker = new DatePicker(context, onDateTimeChanged: handleDatePicker);

    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Card Expense'),
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
                ),
                onChanged: (value) {
                  setState(() {
                    paymentAmountController.updateValue(
                        amountController.numberValue / numberOfPayments);
                  });
                }),
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
            title: FutureBuilder<List<CreditCard>>(
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
                    return DropdownButton<String>(
                        hint: Text("Credit Card"),
                        value: selectedCreditCard,
                        onChanged: (newValue) {
                          setState(() {
                            selectedCreditCard = newValue;
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
          new ListTile(
            leading: const Icon(Icons.refresh),
            title: const Text('Payments'),
            trailing: Switch(
              value: _withPayments,
              onChanged: (value) {
                setState(() {
                  _withPayments = value;
                });
              },
            ),
          ),
          Visibility(
            visible: _withPayments,
            child: new ListTile(
              leading: IconButton(
                icon: new Icon(Icons.keyboard_arrow_left),
                onPressed: numberOfPayments > 1 ? onDecreasePayments : null,
              ),
              title: new Text(
                  "$numberOfPayments x ${paymentAmountController.text}"),
              trailing: IconButton(
                icon: new Icon(Icons.keyboard_arrow_right),
                onPressed: onIncreasePayments,
              ),
            ),
          )
        ],
      ),
    );
  }

  onIncreasePayments() {
    setState(() {
      numberOfPayments++;
      paymentAmountController
          .updateValue(amountController.numberValue / numberOfPayments);
    });
  }

  onDecreasePayments() {
    setState(() {
      numberOfPayments--;
      paymentAmountController
          .updateValue(amountController.numberValue / numberOfPayments);
    });
  }

  handleDatePicker(newDate) {
    setState(() {
      date = newDate;
    });
  }

  onSubmit() {
    String description = descriptionController.text;
    double amount = amountController.numberValue;

    saveCreditCardExpense(_withPayments, numberOfPayments, amount, "ARS",
            description, selectedCreditCard, date)
        .then((result) => {MyNavigator.goToHome(context)});
  }
}
