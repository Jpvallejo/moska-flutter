import 'dart:async';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

Future<String> getAuthToken(String email, String displayName)  async {
  String url = DotEnv().env['BASE_API_URL'] + "/auth";
  dynamic body = {"email": email, "displayName": displayName};
  final response = await http.post(url,
      headers: {'content-type': 'application/json'},
      body: utf8.encode(json.encode(body)));
  if (response.statusCode == 200) {
    return json.decode(response.body)["token"] as String;
  } else {
    print(response.statusCode);
    throw Exception('Failed to get Auth');
  }
}

Future<void> renewAuthToken(Response response) async {
  String newToken = response.headers['X-Renewed-JWT-Token'];
  final storage = new FlutterSecureStorage();
  await storage.write(key: 'authToken', value: newToken);
}
