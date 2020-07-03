import 'dart:async';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:moska_app/src/models/credit_card_model.dart';
import 'package:moska_app/src/models/credit_card_view_model.dart';
import 'package:moska_app/src/services/credit_card_expense_service.dart';

Future<List<CreditCardViewModel>> getCreditCards() async {
  DateTime date = DateTime.now();
  final storage = new FlutterSecureStorage();
  final authToken = await storage.read(key: 'authToken') ?? '';
  dynamic headers = {
    "X-JWT-Token": authToken,
    'content-type': 'application/json'
  };
  String url = DotEnv().env['BASE_API_URL'] + "/creditCards";
  final response = await http.get(url, headers: headers);
  
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    Map<String, dynamic> map = jsonDecode(response.body);
    List<CreditCardViewModel> ccObjs = new List<CreditCardViewModel>();
    List<CreditCard> cards = new List<CreditCard>();
    CreditCardViewModel model;
    double amount;
    map.forEach((key,value) async => {
      cards.add(CreditCard.fromJson(value, key))
    });
    for(var card in cards){
      print(card);
      amount = await getCCExpensesSum(card.id, date.month, date.year);
      print(amount);
      model = new CreditCardViewModel(card.id, card.name, amount);
      print(model.id + " " + model.name + " " + model.totalAmount.toString());
      ccObjs.add(model);
    }

    print(ccObjs);

    return ccObjs;
  } else {
    throw Exception('Failed to get Auth');
  }
}
