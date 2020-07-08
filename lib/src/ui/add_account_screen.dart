import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:moska_app/src/services/account_service.dart';
import 'package:moska_app/src/utils/UnauthorizedException.dart';
import 'package:moska_app/src/utils/my_navigator.dart';

class AddAccountScreen extends StatefulWidget {
  AddAccountScreen({Key key}) : super(key: key);
  @override
  _AddAccountScreenState createState() => new _AddAccountScreenState();
}

class _AddAccountScreenState extends State<AddAccountScreen> {
  MoneyMaskedTextController initialBalanceController =
      MoneyMaskedTextController(decimalSeparator: ',', thousandSeparator: '.');
  TextEditingController nameController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Create Account'),
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
                controller: initialBalanceController,
                decoration: new InputDecoration(
                  hintText: "Initial balance",
                ),
              )),
          new ListTile(
            leading: const Icon(Icons.description),
            title: new TextField(
              controller: nameController,
              decoration: new InputDecoration(
                hintText: "Name",
              ),
            ),
          ),
          new ListTile(
              leading: const Icon(Icons.credit_card),
              title: DropdownButton<String>(
                  hint: Text("Credit Card"),
                  value: "ARS",
                  onChanged: (newValue) {
                    setState(() {});
                  },
                  items: [
                    DropdownMenuItem<String>(
                      child: Text("ARS"),
                      value: "ARS",
                    )
                  ])),
        ],
      ),
    );
  }

  onSubmit() {
    String name = nameController.text;
    double initialBalance = initialBalanceController.numberValue;

    createAccount(initialBalance, "ARS", name)
        .then((result) => {MyNavigator.goToHome(context)})
        .catchError((error) => {
              if (error is UnauthorizedException) MyNavigator.goToLogin(context)
            });
  }
}
