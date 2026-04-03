import 'package:flutter/foundation.dart';
import 'package:report_expences_app/core/result/result.dart';
import 'package:report_expences_app/features/chat/domain/entities/chat_message.dart';
import 'package:report_expences_app/features/chat/domain/use_cases/process_expense_from_chat_use_case.dart';

class ChatViewModel extends ChangeNotifier {
  ChatViewModel({
    required ProcessExpenseFromChatUseCase processExpense,
    Future<void> Function()? artificialDelay,
  })  : _processExpense = processExpense,
        _delay = artificialDelay ?? _instantDelay;

  final ProcessExpenseFromChatUseCase _processExpense;
  final Future<void> Function() _delay;

  static Future<void> _instantDelay() async {}

  final List<ChatMessage> _messages = [];
  int _idSeq = 0;
  int _olderPage = 0;

  bool _isLoadingInitial = false;
  bool _isLoadingOlder = false;
  bool _hasMoreOlder = true;

  List<ChatMessage> get messages => List.unmodifiable(_messages);

  bool get isLoadingInitial => _isLoadingInitial;

  bool get isLoadingOlder => _isLoadingOlder;

  bool get hasMoreOlder => _hasMoreOlder;

  String _nextId() => 'chat_${_idSeq++}';

  Future<void> loadInitial() async {
    if (_messages.isNotEmpty) return;

    _isLoadingInitial = true;
    notifyListeners();
    await _delay();

    final now = DateTime.now().toUtc();
    _messages.add(
      ChatMessage(
        id: _nextId(),
        text:
            'Hola. Describe un gasto en texto libre; usaremos la URL y el token configurados en Ajustes.',
        role: ChatMessageRole.assistant,
        createdAt: now,
      ),
    );

    _isLoadingInitial = false;
    notifyListeners();
  }

  Future<void> loadOlder() async {
    if (!_hasMoreOlder || _isLoadingOlder) return;

    _isLoadingOlder = true;
    notifyListeners();
    await _delay();

    _olderPage += 1;
    final base = DateTime.utc(2026, 3, 20 - _olderPage, 9);
    final batch = <ChatMessage>[
      for (var i = 0; i < 3; i++)
        ChatMessage(
          id: _nextId(),
          text: 'Mensaje antiguo (pagina $_olderPage, $i)',
          role: ChatMessageRole.assistant,
          createdAt: base.subtract(Duration(minutes: i)),
        ),
    ];
    _messages.insertAll(0, batch);

    if (_olderPage >= 2) {
      _hasMoreOlder = false;
    }

    _isLoadingOlder = false;
    notifyListeners();
  }

  Future<void> sendMessage(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    final userTime = DateTime.now().toUtc();
    _messages.add(
      ChatMessage(
        id: _nextId(),
        text: trimmed,
        role: ChatMessageRole.user,
        createdAt: userTime,
      ),
    );
    notifyListeners();

    final result = await _processExpense(trimmed);
    switch (result) {
      case Success(:final data):
        _messages.add(
          ChatMessage(
            id: _nextId(),
            text: data.assistantReply,
            role: ChatMessageRole.assistant,
            createdAt: DateTime.now().toUtc(),
          ),
        );
      case FailureResult(:final failure):
        _messages.add(
          ChatMessage(
            id: _nextId(),
            text: failure.message,
            role: ChatMessageRole.assistant,
            createdAt: DateTime.now().toUtc(),
          ),
        );
    }
    notifyListeners();
  }
}
