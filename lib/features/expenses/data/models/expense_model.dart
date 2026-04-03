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

  /// Parses `GET /api/v1/expenses` list items (`description`, `expenseDate`, …).
  factory ExpenseModel.fromExpenseListItemJson(Map<String, dynamic> json) {
    final dateRaw =
        json['expenseDate'] as String? ?? json['occurredOn'] as String?;
    if (dateRaw == null) {
      throw FormatException('Missing expenseDate or occurredOn');
    }
    final title =
        json['description'] as String? ?? json['title'] as String? ?? '';
    return ExpenseModel(
      id: json['id'] as String,
      title: title,
      amount: (json['amount'] as num).toDouble(),
      occurredOn: DateTime.parse(dateRaw),
    );
  }

  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('expenseDate') ||
        (json.containsKey('description') && !json.containsKey('title'))) {
      return ExpenseModel.fromExpenseListItemJson(json);
    }
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
