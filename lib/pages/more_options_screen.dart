import 'package:flutter/material.dart';
import 'package:moska_app/utils/moska.dart';

class MoreOptionsScreen extends StatefulWidget {
  MoreOptionsScreen({Key key}) : super(key: key);
  @override
  _MoreOptionsScreenState createState() => new _MoreOptionsScreenState();
}

class _MoreOptionsScreenState extends State<MoreOptionsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("MoreOptions Works!"),
    );
  }

}