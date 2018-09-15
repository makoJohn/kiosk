class Salary {
  final int amount;
  final String currency;
  final int percentage;

  Salary(this.amount, this.currency, this.percentage);

  @override
  String toString() {
    if (percentage == null || percentage == 0) {
      return '$amount $currency';
    }
    return '$amount $currency, $percentage%';
  }

  Map toJson() {
    Map map = new Map();
    map["amount"] = amount;
    map["currency"] = currency;
    map["percentage"] = percentage;
    return map;
  }

  Salary.fromJson(Map<String, dynamic> json)
      : amount = json['amount'],
        currency = json['currency'],
        percentage = json['percentage'];
}
