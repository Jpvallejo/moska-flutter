import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moska_app/src/models/credit_card_view_model.dart';
import 'package:moska_app/src/services/credit_card_service.dart';
import 'package:moska_app/src/utils/UnauthorizedException.dart';
import 'package:moska_app/src/utils/my_navigator.dart';

class CreditCardsScreen extends StatefulWidget {
  CreditCardsScreen({Key key}) : super(key: key);
  @override
  _CreditCardsScreenState createState() => new _CreditCardsScreenState();
}

class _CreditCardsScreenState extends State<CreditCardsScreen> {
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
            child: FutureBuilder<List<CreditCardViewModel>>(
                future: getCreditCards(),
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
                                MyNavigator.goToCCExpenses(context, cc);
                              },
                              child: Icon(Icons.credit_card),
                            ),
                            title: GestureDetector(
                                onTap: () {
                                  MyNavigator.goToCCExpenses(context, cc);
                                },
                                child: Text(cc.name)),
                            trailing: GestureDetector(
                                onTap: () {
                                  MyNavigator.goToCCExpenses(context, cc);
                                },
                                child: Text(oCcy.format(cc.totalAmount)))))
                        .toList();
                    return Column(children: rows);
                  }
                }),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: FutureBuilder<double>(
          future: getCreditCardsSum(),
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
