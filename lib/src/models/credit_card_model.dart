class CreditCard {
    String name;
    bool hasLimit;
    int limit;
    int closingDay;
    int paymentDay;

    static fromJson(dynamic parsedJson) {
      print(parsedJson);
    CreditCard creditCard = new CreditCard();
    creditCard.closingDay = int.parse(parsedJson['closingDay']);
    creditCard.name = parsedJson['name'];
    creditCard.hasLimit = parsedJson['hasLimit'];
    creditCard.limit = parsedJson['limit']['amount'];
    creditCard.paymentDay = int.parse(parsedJson['paymentDay']);

    return creditCard;
  }
}