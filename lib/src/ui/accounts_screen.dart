import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moska_app/src/models/account_view_model.dart';
import 'package:moska_app/src/services/account_service.dart';
import 'package:moska_app/src/utils/UnauthorizedException.dart';
import 'package:moska_app/src/utils/my_navigator.dart';

class AccountsScreen extends StatefulWidget {
  AccountsScreen({Key key}) : super(key: key);
  @override
  _AccountsScreenState createState() => new _AccountsScreenState();
}

class _AccountsScreenState extends State<AccountsScreen> {
  List<ListTile> rows;
  List<String> ids;
  final oCcy = new NumberFormat("#,##0.00", "en_US");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          ListTile(
              title: Text(
            DateFormat(DateFormat.MONTH).format(DateTime.now()),
            textAlign: TextAlign.center,
          )),
          SingleChildScrollView(
            child: FutureBuilder<List<AccountViewModel>>(
                future: getAccounts(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return Text("loading");
                  } else if (snapshot.hasError) {
                    if (snapshot.error is UnauthorizedException) {
                      MyNavigator.goToLogin(context);
                    }
                    return Text(snapshot.error.toString());
                  } else {
                    rows = snapshot.data
                        .map((cc) => ListTile(
                            leading: GestureDetector(
                              onTap: () {
                                MyNavigator.goToHome(context, selectedTab:1);
                              },
                              child: Icon(Icons.account_balance_wallet),
                            ),
                            title: GestureDetector(
                                onTap: () {
                                  MyNavigator.goToHome(context, selectedTab:1);
                                },
                                child: Text(cc.name)),
                            trailing: GestureDetector(
                                onTap: () {
                                  MyNavigator.goToHome(context, selectedTab:1);
                                },
                                child: Text(oCcy.format(cc.balance)))))
                        .toList();
                    return Column(children: rows);
                  }
                }),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: FutureBuilder<double>(
          future: getAccountBalancesSum(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return Text("loading");
            } else if (snapshot.hasError) {
              if (snapshot.error is UnauthorizedException) {
                MyNavigator.goToLogin(context);
              }
              return Text(snapshot.error.toString());
            } else {
              return Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text("Total: "),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15.0,15.0,110,15.0),
                    child: Text(oCcy.format(snapshot.data)),
                  )
                ],
              );
            }
          },
        ),
        color: Colors.grey,
      ),
    );
  }
}
