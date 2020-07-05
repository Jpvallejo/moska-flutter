import 'package:intl/intl.dart';
import 'package:moska_app/src/models/transaction_model.dart';

class ExpenseModel extends TransactionModel {
  String accountId;

  static fromJson(dynamic parsedJson, String id) {
    ExpenseModel expense = new ExpenseModel();
    expense.id = id;
    expense.accountId = parsedJson['accountId'];
    expense.date = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(parsedJson['date']);
    expense.amount = double.parse(parsedJson['amount'].toString());
    expense.currency = parsedJson['currency'];
    expense.description = parsedJson['description'];

    return expense;
  }
}