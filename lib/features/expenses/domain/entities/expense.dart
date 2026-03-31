class Expense {
  const Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.occurredOn,
  });

  final String id;
  final String title;
  final double amount;
  final DateTime occurredOn;
}
