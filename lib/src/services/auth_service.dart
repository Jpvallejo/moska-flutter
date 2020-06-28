import 'dart:async';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

Future<String> getAuthToken(String email, String displayName) async {
  String url = DotEnv().env['BASE_API_URL']+ "/auth";
  dynamic body = {
      email: email,
      displayName: displayName
    };
  final response =
      await http.post(url, body: body);

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return json.decode(response.body).token;
  } else {
    throw Exception('Failed to get Auth');
  }
}