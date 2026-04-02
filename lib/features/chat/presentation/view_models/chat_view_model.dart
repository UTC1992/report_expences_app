import 'package:flutter/foundation.dart';
import 'package:report_expences_app/features/chat/domain/entities/chat_message.dart';

class ChatViewModel extends ChangeNotifier {
  ChatViewModel({Future<void> Function()? artificialDelay})
      : _delay = artificialDelay ?? _instantDelay;

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

    final now = DateTime.utc(2026, 3, 31, 12);
    _messages.add(
      ChatMessage(
        id: _nextId(),
        text:
            'Hola. Describe un gasto en texto libre; cuando conectemos el servicio lo procesaremos.',
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

    await _delay();

    _messages.add(
      ChatMessage(
        id: _nextId(),
        text:
            'Recibido. Cuando conectemos el servicio, procesare el gasto desde tu mensaje.',
        role: ChatMessageRole.assistant,
        createdAt: DateTime.now().toUtc(),
      ),
    );
    notifyListeners();
  }
}
