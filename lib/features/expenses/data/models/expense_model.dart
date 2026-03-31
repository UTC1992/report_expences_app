/// Data transfer object; maps to/from transport formats (JSON, API, local DB).
class ExpenseModel {
  const ExpenseModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.occurredOn,
  });

  final String id;
  final String title;
  final double amount;
  final DateTime occurredOn;

  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      id: json['id'] as String,
      title: json['title'] as String,
      amount: (json['amount'] as num).toDouble(),
      occurredOn: DateTime.parse(json['occurredOn'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'amount': amount,
        'occurredOn': occurredOn.toIso8601String(),
      };
}
