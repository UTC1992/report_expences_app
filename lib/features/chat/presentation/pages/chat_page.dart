import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:report_expences_app/features/chat/presentation/view_models/chat_view_model.dart';
import 'package:report_expences_app/features/chat/presentation/widgets/chat_composer.dart';
import 'package:report_expences_app/features/chat/presentation/widgets/chat_messages_body.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      await context.read<ChatViewModel>().loadInitial();
      if (!mounted) return;
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      body: Column(
        children: [
          Expanded(
            child: ChatMessagesBody(scrollController: _scrollController),
          ),
          ChatComposer(onSent: _scrollToBottom),
        ],
      ),
    );
  }
}
