import 'package:http/http.dart';
import 'package:moska_app/src/models/cc_expense_model.dart';

class CCExpenseProvider {
  Client client = Client();
  final _apiKey = 'api-key';

  Future<CCExpenseModel> getExpense() {}
}