class CreditCard {
    String id;
    String name;
    bool hasLimit;
    int limit;
    int closingDay;
    int paymentDay;

    static fromJson(dynamic parsedJson, String id) {
      print(parsedJson);
    CreditCard creditCard = new CreditCard();
    creditCard.id = id;
    creditCard.closingDay = int.parse(parsedJson['closingDay']);
    creditCard.name = parsedJson['name'];
    creditCard.hasLimit = parsedJson['hasLimit'];
    creditCard.limit = parsedJson['limit']['amount'];
    creditCard.paymentDay = int.parse(parsedJson['paymentDay']);

    return creditCard;
  }
}