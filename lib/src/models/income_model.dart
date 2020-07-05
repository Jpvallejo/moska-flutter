import 'package:intl/intl.dart';
import 'package:moska_app/src/models/transaction_model.dart';

class IncomeModel extends TransactionModel {
  String accountId;

  static fromJson(dynamic parsedJson, String id) {
    IncomeModel income = new IncomeModel();
    income.id = id;
    income.accountId = parsedJson['accountId'];
    income.date = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(parsedJson['date']);
    income.amount = double.parse(parsedJson['amount'].toString());
    income.currency = parsedJson['currency'];
    income.description = parsedJson['description'];

    return income;
  }
}