import 'dart:async';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:moska_app/src/models/account_model.dart';
import 'package:moska_app/src/models/account_view_model.dart';
import 'package:moska_app/src/utils/UnauthorizedException.dart';
import 'package:moska_app/src/utils/moska_cache_manager.dart';

String url = DotEnv().env['BASE_API_URL'] + "/accounts";
Future<List<AccountViewModel>> getAccounts() async {
  DateTime date = DateTime.now();
  final storage = new FlutterSecureStorage();
  final authToken = await storage.read(key: 'authToken') ?? '';
  dynamic headers = {
    "X-JWT-Token": authToken,
    'content-type': 'application/json'
  };
  Response response;

  var file = await MoskaCacheManager().getSingleFile(url, headers: headers);
  if (file != null && await file.exists()) {
    var res = await file.readAsString();
    response = Response(res, 200);
  } else {
    response = Response("Error", 400);
  }

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    Map<String, dynamic> map = jsonDecode(response.body);
    List<AccountViewModel> accountObjs = new List<AccountViewModel>();
    List<Account> accounts = new List<Account>();
    AccountViewModel model;
    double balance;
    map.forEach(
        (key, value) async => {accounts.add(Account.fromJson(value, key))});
    for (var account in accounts) {
      balance = account.currentBalance;
      model = new AccountViewModel(account.id, account.name, balance);
      accountObjs.add(model);
    }

    return accountObjs;
  } else {
    throw Exception('Failed to get Auth');
  }
}

Future<double> getAccountBalancesSum() async {
  var accounts = await getAccounts();
  double totalAmount = 0;
  for (var account in accounts) {
    totalAmount += account.balance;
  }

  return totalAmount;
}

Future<String> createAccount(
  double initialBalance,
  String currency,
  String name,
) async {
  final storage = new FlutterSecureStorage();
  final authToken = await storage.read(key: 'authToken') ?? '';
  dynamic headers = {
    "X-JWT-Token": authToken,
    'content-type': 'application/json'
  };
  dynamic body = {
    "name": name,
    "currency": currency,
    "currentBalance": initialBalance
  };

  MoskaCacheManager().removeFile(url);
  final response = await http.post(url,
      headers: headers, body: utf8.encode(json.encode(body)));
print(response.statusCode);
print(response.body);
  if (response.statusCode == 201) {
    return response.body;
  } else if (response.statusCode == 401) {
    throw UnauthorizedException(response.body);
  } else {
    throw Exception(response.body);
  }
}
