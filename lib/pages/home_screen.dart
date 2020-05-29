import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moska_app/pages/dasboard_screen.dart';
import 'package:moska_app/pages/more_options_screen.dart';
import 'package:moska_app/pages/new_item_screen.dart';
import 'package:moska_app/pages/transactions_screen.dart';
import 'package:moska_app/utils/moska.dart';
import 'package:moska_app/pages/budget_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);
  @override
  _HomeScreenState createState() => new _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    DashboardScreen(),
    TransactionsScreen(),
    NewItemScreen(),
    BudgetScreen(),
    MoreOptionsScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(Moska.name),
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: new BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          new BottomNavigationBarItem(
            icon: const Icon(IconData(0xf448,
                fontFamily: CupertinoIcons.iconFont,
                fontPackage: CupertinoIcons.iconFontPackage)),
            title: new Text('Home'),
          ),
          new BottomNavigationBarItem(
            icon: const Icon(IconData(0xf454,
                fontFamily: CupertinoIcons.iconFont,
                fontPackage: CupertinoIcons.iconFontPackage)),
            title: new Text('Transactions'),
          ),
          new BottomNavigationBarItem(
            icon: const Icon(CupertinoIcons.add_circled_solid),
            title: new Text(''),
          ),
          new BottomNavigationBarItem(
            icon: const Icon(IconData(0xf3ee,
                fontFamily: CupertinoIcons.iconFont,
                fontPackage: CupertinoIcons.iconFontPackage)),
            title: new Text('Budget'),
          ),
          new BottomNavigationBarItem(
              icon: const Icon(CupertinoIcons.ellipsis),
              title: new Text('More'))
        ],
        selectedItemColor: Colors.blueAccent[200],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
