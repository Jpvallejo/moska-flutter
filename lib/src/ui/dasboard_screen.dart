import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moska_app/src/services/account_service.dart';
import 'package:moska_app/src/utils/UnauthorizedException.dart';
import 'package:moska_app/src/utils/my_navigator.dart';

class DashboardScreen extends StatefulWidget {
  DashboardScreen({Key key}) : super(key: key);
  @override
  _DashboardScreenState createState() => new _DashboardScreenState();
}

final oCcy = new NumberFormat("#,##0.00", "en_US");

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          _top(),
        ],
      ),
    );
  }
}

_top() {
  return Container(
      padding: EdgeInsets.all(16.0),
      child: FutureBuilder<double>(
        future: getAccountBalancesSum(),
        builder: (context, snapshot) {
          double value = 0;
          if (snapshot.hasError) {
            if (snapshot.error is UnauthorizedException) {
              MyNavigator.goToLogin(context);
            }
            return Text(snapshot.error.toString());
          } else if (snapshot.connectionState == ConnectionState.done) {
            value = snapshot.data;
          }
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text("Current Balance",
                      style: TextStyle(fontSize: 14),
                      textAlign: TextAlign.center),
                  Text(
                    "\$ " + oCcy.format(value),
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  )
                ],
              )
            ],
          );
        },
      ));
}
