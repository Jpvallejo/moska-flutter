import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:moska_app/src/models/credit_card_model.dart';
import 'package:moska_app/src/models/credit_card_view_model.dart';
import 'package:moska_app/src/services/credit_card_expense_service.dart';
import 'package:moska_app/src/utils/moska_cache_manager.dart';

Future<List<CreditCardViewModel>> getCreditCards([DateTime givenDate]) async {
  DateTime date = givenDate == null ? DateTime.now() : givenDate;
  final storage = new FlutterSecureStorage();
  final authToken = await storage.read(key: 'authToken') ?? '';
  dynamic headers = {
    "X-JWT-Token": authToken,
    'content-type': 'application/json'
  };
  String url = DotEnv().env['BASE_API_URL'] + "/creditCards";
  Response response;

  var file = await MoskaCacheManager().getSingleFile(url, headers: headers);
  if (file != null && await file.exists()) {
    var res = await file.readAsString();
    response = Response(res, 200);
  } 
  else {
    response = Response("Error",400);
  }
  // else {
  //   response = await http.get(url, headers: headers);
  //   MoskaCacheManager().putFile(url, response.bodyBytes);
  // }

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    Map<String, dynamic> map = jsonDecode(response.body);
    List<CreditCardViewModel> ccObjs = new List<CreditCardViewModel>();
    List<CreditCard> cards = new List<CreditCard>();
    CreditCardViewModel model;
    double amount;
    map.forEach(
        (key, value) async => {cards.add(CreditCard.fromJson(value, key))});
    for (var card in cards) {
      amount = await getCCExpensesSum(card.id, date.month, date.year);
      model = new CreditCardViewModel(card.id, card.name, amount);
      ccObjs.add(model);
    }

    return ccObjs;
  } else {
    throw Exception('Failed to get Auth');
  }
}

Future<double> getCreditCardsSum([DateTime givenDate]) async {
  var creditCards = await getCreditCards(givenDate);
  double totalAmount = 0;
  for (var card in creditCards ) {
    totalAmount += card.totalAmount;
  }

  return totalAmount;
}
