import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:moska_app/src/ui/budget_screen.dart';
import 'package:moska_app/src/ui/credit_cards_screen.dart';
import 'package:moska_app/src/ui/dasboard_screen.dart';
import 'package:moska_app/src/ui/more_options_screen.dart';
import 'package:moska_app/src/ui/new_item_screen.dart';
import 'package:moska_app/src/ui/transactions_screen.dart';
import 'package:moska_app/src/utils/modal_fit_dialog.dart';
import 'package:moska_app/src/utils/moska.dart';
import 'package:moska_app/src/utils/my_navigator.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Properties & Variables needed

  int _currentIndex = 0;
  final List<Widget> _children = [
    DashboardScreen(),
    TransactionsScreen(),
    CreditCardsScreen(),
    BudgetScreen(),
    MoreOptionsScreen(),
  ]; // to store nested tabs
  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = DashboardScreen(); // Our first view in viewport

  @override
  void initState() {
    int args;
    Future.delayed(Duration.zero, () {
      setState(() {
        args = ModalRoute.of(context).settings.arguments;
      });
      print(args);
      onTabTapped(args);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final storage = new FlutterSecureStorage();
    var imageUrl = storage.read(key: 'imageUrl');
    return Scaffold(
      appBar: new AppBar(
        title: new Text(Moska.name),
        leading: new GestureDetector(
          child: FutureBuilder<String>(
            future: imageUrl,
            builder: (context, snapshot) {
              String url = '';
              if (snapshot.connectionState == ConnectionState.done) {
                url = snapshot.data;
              }
              return Padding(
                padding: EdgeInsets.all(10.0),
                child: Container(
                  decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      image: new DecorationImage(
                          fit: BoxFit.cover, image: new NetworkImage(url))),
                ),
              );
            },
          ),
          onTap: () => MyNavigator.goToProfile(context),
        ),
      ),
      body: PageStorage(
        child: currentScreen,
        bucket: bucket,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
          child: Icon(CupertinoIcons.add, size: 40),
          onPressed: () {
            // MyNavigator.goToCreateCCExpense(context);
            showCupertinoModalBottomSheet(
              expand: false,
              context: context,
              backgroundColor: Colors.transparent,
              builder: (context, scrollController) =>
                  ModalFit(scrollController: scrollController),
            );
          }),
      bottomNavigationBar: BottomAppBar(
        clipBehavior: Clip.antiAlias,
        shape: CircularNotchedRectangle(),
        child: new BottomNavigationBar(
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
              icon: const Icon(Icons.credit_card),
              title: new Text('Cards'),
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
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      currentScreen = _children[index];
    });
  }
}
