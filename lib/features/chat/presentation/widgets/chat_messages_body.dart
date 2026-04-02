import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:report_expences_app/features/chat/presentation/view_models/chat_view_model.dart';
import 'package:report_expences_app/features/chat/presentation/widgets/chat_message_bubble.dart';

class ChatMessagesBody extends StatefulWidget {
  const ChatMessagesBody({super.key, required this.scrollController});

  final ScrollController scrollController;

  @override
  State<ChatMessagesBody> createState() => _ChatMessagesBodyState();
}

class _ChatMessagesBodyState extends State<ChatMessagesBody> {
  bool _loadingOlderLatch = false;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    if (!widget.scrollController.hasClients) return;
    final vm = context.read<ChatViewModel>();
    if (!vm.hasMoreOlder || vm.isLoadingOlder || _loadingOlderLatch) return;

    final pos = widget.scrollController.position;
    if (pos.maxScrollExtent <= 0) return;
    if (pos.pixels > 120) return;

    _loadOlderPreservingScroll();
  }

  Future<void> _loadOlderPreservingScroll() async {
    final vm = context.read<ChatViewModel>();
    if (!vm.hasMoreOlder || vm.isLoadingOlder) return;

    _loadingOlderLatch = true;
    final controller = widget.scrollController;
    if (!controller.hasClients) {
      _loadingOlderLatch = false;
      return;
    }
    final oldMax = controller.position.maxScrollExtent;

    await vm.loadOlder();
    if (!mounted) {
      _loadingOlderLatch = false;
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadingOlderLatch = false;
      if (!mounted || !controller.hasClients) return;
      final newMax = controller.position.maxScrollExtent;
      final delta = newMax - oldMax;
      final target = (controller.offset + delta).clamp(0.0, newMax);
      controller.jumpTo(target);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatViewModel>(
      builder: (context, vm, _) {
        if (vm.isLoadingInitial && vm.messages.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (vm.messages.isEmpty) {
          return const Center(child: Text('No hay mensajes aún.'));
        }

        return ListView.builder(
          controller: widget.scrollController,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          itemCount: vm.messages.length + (vm.isLoadingOlder ? 1 : 0),
          itemBuilder: (context, index) {
            if (vm.isLoadingOlder && index == 0) {
              return const Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Center(
                  child: SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              );
            }
            final msgIndex = vm.isLoadingOlder ? index - 1 : index;
            final message = vm.messages[msgIndex];
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: ChatMessageBubble(message: message),
            );
          },
        );
      },
    );
  }
}
