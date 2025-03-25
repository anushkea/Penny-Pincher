// transaction.dart
class Transaction {
  String category;
  double amount;
  String type;
  DateTime date;

  Transaction({
    required this.category,
    required this.amount,
    required this.type,
    required this.date,
  });
}
