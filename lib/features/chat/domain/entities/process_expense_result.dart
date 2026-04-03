class ProcessExpenseResult {
  const ProcessExpenseResult({
    required this.saved,
    required this.duplicate,
    this.expenseId,
    required this.assistantReply,
  });

  final bool saved;
  final bool duplicate;
  final String? expenseId;
  final String assistantReply;
}
