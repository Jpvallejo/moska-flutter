import 'dart:async';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

Future<String> getAuthToken(String email, String displayName)  async {
  String url = DotEnv().env['BASE_API_URL'] + "/auth";
  print(url);
  dynamic body = {"email": email, "displayName": displayName};
  print(json.encode(body));
  final response = await http.post(url,
      headers: {'content-type': 'application/json'},
      body: utf8.encode(json.encode(body)));
  print(response.statusCode);
  print(response.body);
  if (response.statusCode == 201) {
    print(json.decode(response.body));
    return json.decode(response.body)["token"] as String;
  } else {
    throw Exception('Failed to get Auth');
  }
}
