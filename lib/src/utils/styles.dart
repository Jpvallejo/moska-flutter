import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Styles {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return isDarkTheme
        ? ThemeData.dark().copyWith(
            primaryTextTheme: TextTheme(headline1: TextStyle(color: Colors.white)))
        : ThemeData.light().copyWith(
            primaryTextTheme: TextTheme(headline1: TextStyle(color: Colors.black)));
  }
}
