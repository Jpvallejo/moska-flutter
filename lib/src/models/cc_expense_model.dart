import 'package:moska_app/src/models/transaction_model.dart';

class CCExpenseModel extends TransactionModel {
  String creditCardId;

  static fromJson(Map<String, dynamic> parsedJson) {
    CCExpenseModel expense = new CCExpenseModel();
    expense.creditCardId = parsedJson['creditCardId'];
    expense.date = DateTime.parse(parsedJson['date']);
    expense.amount = parsedJson['amount'];
    expense.currency = parsedJson['currency'];

    return expense;
  }
}