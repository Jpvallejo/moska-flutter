abstract class TransactionModel {
  String id;
  double amount;
  String description;
  DateTime date = DateTime.now();
  String currency;
}