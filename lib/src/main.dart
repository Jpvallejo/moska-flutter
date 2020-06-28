import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:moska_app/src/resources/dark_theme_provider.dart';
import 'package:moska_app/src/ui/add_credit_card_expense_screen.dart';
import 'package:moska_app/src/ui/home_screen.dart';
import 'package:moska_app/src/ui/login_screen.dart';
import 'package:moska_app/src/ui/profile_screen.dart';
import 'package:moska_app/src/ui/splash_screen.dart';
import 'package:moska_app/src/utils/styles.dart';

var routes = <String, WidgetBuilder>{
  '/home': (BuildContext context) => HomeScreen(),
  '/ccExpense/create': (BuildContext context) => AddCCExpenseScreen(),
  '/login': (BuildContext context) => LoginScreen(),
  '/profile': (BuildContext context) => ProfileScreen()
};

Future main() async {
  await DotEnv().load('.env');
  runApp(MoskaApp());
}

class MoskaApp extends StatefulWidget {
  @override
  _MoskaAppState createState() => _MoskaAppState();
}

class _MoskaAppState extends State<MoskaApp> {
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
