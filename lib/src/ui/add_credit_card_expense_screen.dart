import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:intl/intl.dart';
import 'package:moska_app/src/utils/datepicker.dart';


class AddCCExpenseScreen extends StatefulWidget {
  AddCCExpenseScreen({Key key}) : super(key: key);
  @override
  _AddCCExpenseScreenState createState() => new _AddCCExpenseScreenState();
}

class _AddCCExpenseScreenState extends State<AddCCExpenseScreen> {
  bool _withPayments = false;
  int numberOfPayments = 1;
  double amount = 0.0;
  MoneyMaskedTextController amountController =
      MoneyMaskedTextController(decimalSeparator: ',', thousandSeparator: '.');
  MoneyMaskedTextController paymentAmountController =
      MoneyMaskedTextController(decimalSeparator: ',', thousandSeparator: '.');
  DateTime date = DateTime.now();
  DatePicker datePicker;

  @override
  Widget build(BuildContext context) {
    datePicker = new DatePicker(context, onDateTimeChanged: handleDatePicker);
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return new Scaffold(
      appBar: new AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: new Text('Card Expense'),
        actions: <Widget>[
          new IconButton(icon: const Icon(Icons.save), onPressed: () {})
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
              decoration: new InputDecoration(
                hintText: "Description",
              ),
            ),
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
}
