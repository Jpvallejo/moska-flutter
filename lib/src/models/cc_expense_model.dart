import 'package:moska_app/src/models/transaction_model.dart';

class CCExpenseModel extends TransactionModel {
  String creditCardId;

  static fromJson(dynamic parsedJson, String id) {
    CCExpenseModel expense = new CCExpenseModel();
    expense.id = id;
    expense.creditCardId = parsedJson['creditCardId'];
    expense.date = DateTime.parse(parsedJson['date']);
    expense.amount = parsedJson['amount'];
    expense.currency = parsedJson['currency'];

    return expense;
  }
}