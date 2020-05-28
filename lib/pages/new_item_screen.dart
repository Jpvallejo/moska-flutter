import 'package:flutter/material.dart';
import 'package:moska_app/utils/moska.dart';

class NewItemScreen extends StatefulWidget {
  NewItemScreen({Key key}) : super(key: key);
  @override
  _NewItemScreenState createState() => new _NewItemScreenState();
}

class _NewItemScreenState extends State<NewItemScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("NewItem Works!"),
    );
  }

}