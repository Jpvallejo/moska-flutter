import 'dart:async';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:moska_app/src/models/cc_expense_model.dart';
import 'package:moska_app/src/utils/UnauthorizedException.dart';
import 'package:moska_app/src/utils/moska_cache_manager.dart';
import 'package:moska_app/src/utils/my_navigator.dart';

import 'auth_service.dart';

String url = DotEnv().env['BASE_API_URL'] + "/ccSpendings";

Future<List<CCExpenseModel>> getCreditCardExpenses(String creditCardId, int month, int year) async {
  final storage = new FlutterSecureStorage();
  final authToken = await storage.read(key: 'authToken') ?? '';
  dynamic headers = {
    "X-JWT-Token": authToken,
    'content-type': 'application/json'
  };
  Response response;
    var finalUrl = url + "/byAccount/$creditCardId?month=$month&year=$year";
    var file = await MoskaCacheManager().getSingleFile(finalUrl, headers: headers);
    if (file != null && await file.exists()) {
      var res = await file.readAsString();
      response = Response(res, 200);
    } 
    else {
      response = Response("Error",400);
    }

  if (response.statusCode == 200) {
    renewAuthToken(response);
    // If the server did return a 200 OK response,
    // then parse the JSON.
    Map<String, dynamic> map = jsonDecode(response.body);
    List<CCExpenseModel> ccObjs = new List<CCExpenseModel>();
    map.forEach(
        (key, value) => {ccObjs.add(CCExpenseModel.fromJson(value, key))});

    return ccObjs;
  } else if(response.statusCode == 401) {
    throw UnauthorizedException("Unauthorized");
  }
  else {
    throw Exception('There\'s no credit card expenses');
  }
}

Future<double> getCCExpensesSum(String creditCardId, int month, int year) async {
  final storage = new FlutterSecureStorage();
  final authToken = await storage.read(key: 'authToken') ?? '';
  dynamic headers = {
    "X-JWT-Token": authToken,
    'content-type': 'application/json'
  };
  Response response;
  var finalUrl = url + "/byAccount/$creditCardId?month=$month&year=$year";
  var file = await MoskaCacheManager().getSingleFile(finalUrl, headers: headers);
  if (file != null && await file.exists()) {
    var res = await file.readAsString();
    response = Response(res, 200);
  } 
  else {
    response = Response("Error",400);
  }
  //final response = await http.get(url + "/byAccount/$creditCardId?month=$month&year=$year" , headers: headers);

  if (response.statusCode == 200) {
    renewAuthToken(response);
    // If the server did return a 200 OK response,
    // then parse the JSON.
    Map<String, dynamic> map = jsonDecode(response.body);
    double sum = 0;
    map.forEach(
        (key, value) => { sum += value["amount"]});

    return sum;
  } else if(response.statusCode == 401) {
    throw UnauthorizedException("Unauthorized");
  }
  else {
    throw Exception('There\'s no credit card expenses');
  }
}

Future<double> getCCExpensesTotalSum(List<String> ids) async {
  DateTime date = DateTime.now();
  int month = date.month;
  int year = date.year;
  final storage = new FlutterSecureStorage();
  final authToken = await storage.read(key: 'authToken') ?? '';
  double totalAmount = 0;
  dynamic headers = {
    "X-JWT-Token": authToken,
    'content-type': 'application/json'
  };

  ids.forEach((creditCardId) async {
    totalAmount += await getCCExpensesSum(creditCardId, month, year);
  });

  return totalAmount;
}

Future<String> saveCreditCardExpense(
    bool hasPayments,
    int payments,
    double amount,
    String currency,
    String description,
    String creditCardId,
    DateTime date) async {
  final storage = new FlutterSecureStorage();
  final authToken = await storage.read(key: 'authToken') ?? '';
  dynamic headers = {
    "X-JWT-Token": authToken,
    'content-type': 'application/json'
  };
  String postUrl;
  dynamic body;
  if (hasPayments) {
    body = {
      "payments": payments,
      "spending": {
        "amount": amount,
        "currency": currency,
        "description": description,
        "creditCardId": creditCardId,
        "date": DateFormat('MM-dd-yyyy').format(date)
      }
    };
    postUrl = url + "/payments";
  } else {
    postUrl = url;
    body = {
      "amount": amount,
      "currency": currency,
      "description": description,
      "creditCardId": creditCardId,
      "date": DateFormat('MM-dd-yyyy').format(date)
    };
  }

  MoskaCacheManager().removeFile(url + "/byAccount/$creditCardId?month=${date.month}&year=${date.year}");
  final response = await http.post(postUrl, headers: headers, body: utf8.encode(json.encode(body)));

  if (response.statusCode == 201) {
    return response.body;
  } else if (response.statusCode == 401) {
    throw UnauthorizedException(response.body);
  }
  else {
    throw Exception(response.body);
  }

}
