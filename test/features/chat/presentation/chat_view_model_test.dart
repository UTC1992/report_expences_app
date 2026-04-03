import 'package:flutter_test/flutter_test.dart';
import 'package:report_expences_app/core/result/result.dart';
import 'package:report_expences_app/features/chat/domain/entities/chat_message.dart';
import 'package:report_expences_app/features/chat/domain/entities/process_expense_result.dart';
import 'package:report_expences_app/features/chat/domain/repositories/chat_repository.dart';
import 'package:report_expences_app/features/chat/domain/use_cases/process_expense_from_chat_use_case.dart';
import 'package:report_expences_app/features/chat/presentation/view_models/chat_view_model.dart';

class _FakeChatRepository implements ChatRepository {
  @override
  Future<Result<ProcessExpenseResult>> processExpenseText(String text) async {
    return Success(
      ProcessExpenseResult(
        saved: true,
        duplicate: false,
        expenseId: '1',
        assistantReply: 'Procesado (prueba).',
      ),
    );
  }
}

ProcessExpenseFromChatUseCase _makeStubProcessExpense() {
  return ProcessExpenseFromChatUseCase(_FakeChatRepository());
}

void main() {
  Future<void> noDelay() async {}

  test('starts empty and not loading', () {
    final vm = ChatViewModel(
      artificialDelay: noDelay,
      processExpense: _makeStubProcessExpense(),
    );
    expect(vm.messages, isEmpty);
    expect(vm.isLoadingInitial, isFalse);
    expect(vm.isLoadingOlder, isFalse);
  });

  test('loadInitial fills messages and ends loading', () async {
    final vm = ChatViewModel(
      artificialDelay: noDelay,
      processExpense: _makeStubProcessExpense(),
    );
    expect(vm.hasMoreOlder, isTrue);

    final future = vm.loadInitial();
    expect(vm.isLoadingInitial, isTrue);
    await future;

    expect(vm.isLoadingInitial, isFalse);
    expect(vm.messages, isNotEmpty);
    expect(vm.messages.first.role, ChatMessageRole.assistant);
  });

  test('loadInitial is idempotent when messages already exist', () async {
    final vm = ChatViewModel(
      artificialDelay: noDelay,
      processExpense: _makeStubProcessExpense(),
    );
    await vm.loadInitial();
    final firstIds = vm.messages.map((m) => m.id).toList();

    await vm.loadInitial();
    expect(vm.messages.map((m) => m.id).toList(), firstIds);
  });

  test('sendMessage ignores blank text', () async {
    final vm = ChatViewModel(
      artificialDelay: noDelay,
      processExpense: _makeStubProcessExpense(),
    );
    await vm.loadInitial();
    final n = vm.messages.length;

    await vm.sendMessage('   ');
    await vm.sendMessage('');
    expect(vm.messages.length, n);
  });

  test('sendMessage appends user then assistant', () async {
    final vm = ChatViewModel(
      artificialDelay: noDelay,
      processExpense: _makeStubProcessExpense(),
    );
    await vm.loadInitial();
    final n = vm.messages.length;

    await vm.sendMessage('Cafe 5 euros');

    expect(vm.messages.length, n + 2);
    expect(vm.messages[n].role, ChatMessageRole.user);
    expect(vm.messages[n].text, 'Cafe 5 euros');
    expect(vm.messages[n + 1].role, ChatMessageRole.assistant);
    expect(vm.messages[n + 1].text, 'Procesado (prueba).');
  });

  test('loadOlder prepends messages and can exhaust hasMoreOlder', () async {
    final vm = ChatViewModel(
      artificialDelay: noDelay,
      processExpense: _makeStubProcessExpense(),
    );
    await vm.loadInitial();
    final topIdBefore = vm.messages.first.id;

    await vm.loadOlder();
    expect(vm.isLoadingOlder, isFalse);
    expect(vm.messages.first.id, isNot(topIdBefore));
    expect(vm.messages.length, greaterThan(3));

    await vm.loadOlder();
    await vm.loadOlder();

    expect(vm.hasMoreOlder, isFalse);
    final len = vm.messages.length;
    await vm.loadOlder();
    expect(vm.messages.length, len);
  });
}
