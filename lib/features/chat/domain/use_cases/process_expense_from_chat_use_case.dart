import 'package:report_expences_app/core/result/result.dart';
import 'package:report_expences_app/features/chat/domain/entities/process_expense_result.dart';
import 'package:report_expences_app/features/chat/domain/repositories/chat_repository.dart';

class ProcessExpenseFromChatUseCase {
  ProcessExpenseFromChatUseCase(this._repository);

  final ChatRepository _repository;

  Future<Result<ProcessExpenseResult>> call(String text) =>
      _repository.processExpenseText(text);
}
