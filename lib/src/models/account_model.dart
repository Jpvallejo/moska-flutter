class Account {
  String id;
  double currentBalance;
  String name;
  String currency;

  static fromJson(dynamic parsedJson, String id) {
    Account account = new Account();
    account.id = id;
    account.name = parsedJson['name'];
    account.currentBalance = parsedJson['currentBalance'].toDouble();
    account.currency = parsedJson['currency'];

    return account;
  }
}