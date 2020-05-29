import 'package:flutter/material.dart';
import 'package:moska_app/notifiers/dark_theme_provider.dart';
import 'package:moska_app/pages/add_credit_card_expense_screen.dart';
import 'package:moska_app/pages/home_screen.dart';
import 'package:moska_app/pages/splash_screen.dart';
import 'package:moska_app/utils/styles.dart';

var routes = <String, WidgetBuilder>{
  '/home': (BuildContext context) => HomeScreen(),
  '/ccExpense/create': (BuildContext context) => AddCCExpenseScreen()
};

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider = new DarkThemeProvider();

  @override
  void initState() {
    super.initState();
    getCurrentAppTheme();
  }

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
        await themeChangeProvider.darkThemePreference.getTheme();
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: Styles.themeData(themeChangeProvider.darkTheme, context),
        home: SplashScreen(),
        routes: routes);
  }
}
