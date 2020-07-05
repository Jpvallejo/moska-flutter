import 'dart:async';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:moska_app/src/models/cc_expense_model.dart';
import 'package:moska_app/src/models/expense_model.dart';
import 'package:moska_app/src/models/transaction_model.dart';
import 'package:moska_app/src/services/account_service.dart';
import 'package:moska_app/src/services/credit_card_service.dart';
import 'package:moska_app/src/services/expense_service.dart';
import 'package:moska_app/src/services/income_service.dart';
import 'package:moska_app/src/utils/UnauthorizedException.dart';
import 'package:moska_app/src/utils/moska_cache_manager.dart';
import 'package:moska_app/src/utils/my_navigator.dart';

import 'auth_service.dart';

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
