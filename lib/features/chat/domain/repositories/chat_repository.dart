import 'package:report_expences_app/core/result/result.dart';
import 'package:report_expences_app/features/chat/domain/entities/process_expense_result.dart';

abstract class ChatRepository {
  Future<Result<ProcessExpenseResult>> processExpenseText(String text);
}
