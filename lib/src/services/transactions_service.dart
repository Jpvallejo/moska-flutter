import 'dart:async';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:moska_app/src/models/transaction_model.dart';
import 'package:moska_app/src/services/account_service.dart';
import 'package:moska_app/src/services/expense_service.dart';
import 'package:moska_app/src/services/income_service.dart';

String url = DotEnv().env['BASE_API_URL'] + "/expenses";

Future<List<TransactionModel>> getTransactions(int month, int year) async {
  var accounts = await getAccounts();
  // var creditCards = await getCreditCards();
  var transactions = new List<TransactionModel>();

  for(var account in accounts) {
    var expenses = await getExpenses(account.id, month, year);
    var incomes = await getIncomes(account.id, month, year);

    transactions.addAll(expenses);
    transactions.addAll(incomes);
  }

  transactions.sort((a,b) {
    return a.date.compareTo(b.date);
  });

  return transactions;
}
