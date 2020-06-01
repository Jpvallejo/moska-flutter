import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:moska_app/src/utils/moska.dart';
import 'package:moska_app/src/utils/my_navigator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 5), () => navigateUser(context));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: Colors.green,
                        radius: 50.0,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10.0),
                      ),
                      Text(
                        Moska.name,
                        style: TextStyle(
                            color: Colors.greenAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 24.0),
                      )
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

navigateUser(BuildContext context) async {
  final storage = new FlutterSecureStorage();
  bool isLoggedIn = await storage.read(key: 'isLoggedIn') == 'true';
  DateTime logInTime = DateTime.parse(await storage.read(key: 'logInTime'));

  if (isLoggedIn &&
      DateTime.now().isBefore(logInTime.add(new Duration(days: 1)))) {
    MyNavigator.goToHome(context);
  } else {
    if (isLoggedIn) {
      storage.deleteAll();
    }
    MyNavigator.goToLogin(context);
  }
}
