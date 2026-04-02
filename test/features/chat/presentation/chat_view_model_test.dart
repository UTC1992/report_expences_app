import 'package:flutter_test/flutter_test.dart';
import 'package:report_expences_app/features/chat/domain/entities/chat_message.dart';
import 'package:report_expences_app/features/chat/presentation/view_models/chat_view_model.dart';

void main() {
  Future<void> noDelay() async {}

  test('starts empty and not loading', () {
    final vm = ChatViewModel(artificialDelay: noDelay);
    expect(vm.messages, isEmpty);
    expect(vm.isLoadingInitial, isFalse);
    expect(vm.isLoadingOlder, isFalse);
  });

  test('loadInitial fills messages and ends loading', () async {
    final vm = ChatViewModel(artificialDelay: noDelay);
    expect(vm.hasMoreOlder, isTrue);

    final future = vm.loadInitial();
    expect(vm.isLoadingInitial, isTrue);
    await future;

    expect(vm.isLoadingInitial, isFalse);
    expect(vm.messages, isNotEmpty);
    expect(vm.messages.first.role, ChatMessageRole.assistant);
  });

  test('loadInitial is idempotent when messages already exist', () async {
    final vm = ChatViewModel(artificialDelay: noDelay);
    await vm.loadInitial();
    final firstIds = vm.messages.map((m) => m.id).toList();

    await vm.loadInitial();
    expect(vm.messages.map((m) => m.id).toList(), firstIds);
  });

  test('sendMessage ignores blank text', () async {
    final vm = ChatViewModel(artificialDelay: noDelay);
    await vm.loadInitial();
    final n = vm.messages.length;

    await vm.sendMessage('   ');
    await vm.sendMessage('');
    expect(vm.messages.length, n);
  });

  test('sendMessage appends user then assistant', () async {
    final vm = ChatViewModel(artificialDelay: noDelay);
    await vm.loadInitial();
    final n = vm.messages.length;

    await vm.sendMessage('Cafe 5 euros');

    expect(vm.messages.length, n + 2);
    expect(vm.messages[n].role, ChatMessageRole.user);
    expect(vm.messages[n].text, 'Cafe 5 euros');
    expect(vm.messages[n + 1].role, ChatMessageRole.assistant);
    expect(vm.messages[n + 1].text, isNotEmpty);
  });

  test('loadOlder prepends messages and can exhaust hasMoreOlder', () async {
    final vm = ChatViewModel(artificialDelay: noDelay);
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
