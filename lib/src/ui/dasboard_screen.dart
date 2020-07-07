import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:moska_app/src/services/account_service.dart';
import 'package:moska_app/src/services/credit_card_service.dart';
import 'package:moska_app/src/services/expense_service.dart';
import 'package:moska_app/src/services/income_service.dart';
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
    final primaryColor = Theme.of(context).textTheme.headline1.color;
    return Scaffold(
        body: StaggeredGridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12.0,
      mainAxisSpacing: 12.0,
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      children: <Widget>[
        _buildTile(
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  FutureBuilder<double>(
                    future: getAccountBalancesSum(),
                    builder: (context, snapshot) {
                      double value = 0;
                      if (snapshot.hasError) {
                        if (snapshot.error is UnauthorizedException) {
                          MyNavigator.goToLogin(context);
                        }
                        return Text(snapshot.error.toString());
                      } else if (snapshot.connectionState ==
                          ConnectionState.done) {
                        value = snapshot.data;
                      }
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Balance',
                                  style: TextStyle(color: Colors.blueAccent)),
                              Text("\$ " + oCcy.format(value),
                                  style: TextStyle(
                                      color: primaryColor,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 30.0))
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ]),
          ),
          onTap: () => MyNavigator.goToAccounts(context)
        ),
        _buildTile(
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  FutureBuilder<double>(
                    future: getIncomesTotalSum(),
                    builder: (context, snapshot) {
                      double value = 0;
                      if (snapshot.hasError) {
                        if (snapshot.error is UnauthorizedException) {
                          MyNavigator.goToLogin(context);
                        }
                        return Text(snapshot.error.toString());
                      } else if (snapshot.connectionState ==
                          ConnectionState.done) {
                        value = snapshot.data;
                      }
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Incomes',
                                  style: TextStyle(
                                      color: primaryColor,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20.0)),
                              Text('\$ ' + oCcy.format(value),
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20.0)),
                            ],
                          ),
                        ],
                      );
                    },
                  )
                ]),
          )
        ),
        _buildTile(
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  FutureBuilder<double>(
                    future: getExpensesTotalSum(),
                    builder: (context, snapshot) {
                      double value = 0;
                      if (snapshot.hasError) {
                        if (snapshot.error is UnauthorizedException) {
                          MyNavigator.goToLogin(context);
                        }
                        return Text(snapshot.error.toString());
                      } else if (snapshot.connectionState ==
                          ConnectionState.done) {
                        value = snapshot.data;
                      }
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Expenses',
                                  style: TextStyle(
                                      color: primaryColor,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20.0)),
                              Text('\$ ' + oCcy.format(value),
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20.0)),
                            ],
                          ),
                        ],
                      );
                    },
                  )
                ]),
          ),
        ),
        _buildTile(
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  FutureBuilder<double>(
                    future: getCreditCardsSum(new DateTime(DateTime.now().year, DateTime.now().month - 1, 1)),
                    builder: (context, snapshot) {
                      double value = 0;
                      if (snapshot.hasError) {
                        if (snapshot.error is UnauthorizedException) {
                          MyNavigator.goToLogin(context);
                        }
                        return Text(snapshot.error.toString());
                      } else if (snapshot.connectionState ==
                          ConnectionState.done) {
                        value = snapshot.data;
                      }
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Credit Cards',
                                  style: TextStyle(
                                      color: primaryColor,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20.0)),
                              Text('\$ ' + oCcy.format(value),
                                  style: TextStyle(
                                      color: Colors.black45,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 24.0)),
                            ],
                          ),
                        ],
                      );
                    },
                  )
                ]),
          ),
          onTap: () => MyNavigator.goToHome(context, selectedTab: 2)
        ),
      ],
      staggeredTiles: [
        StaggeredTile.extent(2, 110.0),
        StaggeredTile.extent(1, 110.0),
        StaggeredTile.extent(1, 110.0),
        StaggeredTile.extent(2, 110.0),
      ],
    ));
  }

  Widget _buildTile(Widget child, {Function() onTap}) {
    return Material(
        elevation: 14.0,
        borderRadius: BorderRadius.circular(12.0),

        child: InkWell(
            // Do onTap() if it isn't null, otherwise do print()
            onTap: onTap != null
                ? () => onTap()
                : () {
                    print('Not set yet');
                  },
            child: child));
  }
}
