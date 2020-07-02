import 'package:intl/intl.dart';
import 'package:moska_app/src/models/transaction_model.dart';

class CCExpenseModel extends TransactionModel {
  String creditCardId;

  static fromJson(dynamic parsedJson, String id) {
    CCExpenseModel expense = new CCExpenseModel();
    expense.id = id;
    expense.creditCardId = parsedJson['creditCardId'];
    expense.date = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(parsedJson['date']);
    expense.amount = double.parse(parsedJson['amount'].toString());
    expense.currency = parsedJson['currency'];
    expense.description = parsedJson['description'];

    return expense;
  }
}