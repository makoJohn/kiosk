class CalculatedSalary {
  final double totalHours;
  final int amount;
  final String currency;
  final int totalEarnings;
  final int percentageFromEarnings;
  final int totalForHours;

  CalculatedSalary(this.totalHours, this.amount, this.currency,
      this.totalEarnings, this.percentageFromEarnings, this.totalForHours);

  @override
  String toString() {
    return '$amount $currency (${totalHours.toStringAsFixed(1)} h.)';
  }
}
