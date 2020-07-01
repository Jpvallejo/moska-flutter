import 'dart:async';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:moska_app/src/models/credit_card_model.dart';

Future<List<CreditCard>> getCreditCards() async {
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
    List<CreditCard> ccObjs = new List<CreditCard>();
    map.forEach((key,value) => {
      ccObjs.add(CreditCard.fromJson(value, key))
    });
    print(ccObjs);
    return ccObjs;
  } else {
    throw Exception('Failed to get Auth');
  }
}
