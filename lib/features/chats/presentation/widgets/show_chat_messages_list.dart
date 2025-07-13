import 'package:flutter/material.dart';
import 'package:whatsapp/core/widgets/vertical_gap.dart';
import 'package:whatsapp/features/chats/domain/entities/message_entity.dart';
import 'package:whatsapp/features/chats/presentation/widgets/bubble_message_item.dart';
import 'package:whatsapp/features/chats/presentation/widgets/show_message_options_menu.dart';
import 'package:whatsapp/features/chats/presentation/widgets/swipe_to_reply_message_item.dart';

class ShowChatMessagesList extends StatefulWidget {
  const ShowChatMessagesList({
    super.key,
    required this.scrollController,
    required this.messages,
    this.onReplyRequested,
    this.isTyping = false,
  });

  final ScrollController scrollController;
  final List<MessageEntity> messages;
  final void Function(MessageEntity message)? onReplyRequested;
  final bool isTyping;

  @override
  State<ShowChatMessagesList> createState() => _ShowChatMessagesListState();
}

class _ShowChatMessagesListState extends State<ShowChatMessagesList> {
  bool _showScrollDownButton = false;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final position = widget.scrollController.position;
    final threshold = 400;

    if (position.maxScrollExtent - position.pixels > threshold) {
      if (!_showScrollDownButton) {
        setState(() => _showScrollDownButton = true);
      }
    } else {
      if (_showScrollDownButton) {
        setState(() => _showScrollDownButton = false);
      }
    }
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!widget.scrollController.hasClients) return;

      final position = widget.scrollController.position;
      final target = position.maxScrollExtent;

      widget.scrollController.animateTo(
        target,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );

      Future.delayed(const Duration(milliseconds: 350), () {
        if (!widget.scrollController.hasClients) return;
        final newTarget = widget.scrollController.position.maxScrollExtent;
        if (widget.scrollController.offset < newTarget - 20) {
          widget.scrollController.animateTo(
            newTarget,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final totalItemCount = widget.messages.length + (widget.isTyping ? 1 : 0);

    return Stack(
      children: [
        ListView.separated(
          controller: widget.scrollController,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          itemCount: totalItemCount,
          separatorBuilder: (context, index) => const VerticalGap(8),
          itemBuilder: (context, index) {
            if (widget.isTyping && index == totalItemCount - 1) {
              return const BubbleMessageItem(
                isFromMe: false,
                isTyping: true,
              );
            }

            final msg = widget.messages[index];
            final isFromMe = msg.isFromMe;
            final bool isLastFromSameSender =
                index == widget.messages.length - 1 ||
                    widget.messages[index + 1].senderId != msg.senderId;

            final bool isRepliedMessage = msg.parentId != null;
            MessageEntity? repliedMsg;
            if (isRepliedMessage) {
              repliedMsg = widget.messages.firstWhere(
                (message) => message.id == msg.parentId,
                orElse: () => msg,
              );
            }

            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onLongPress: () => showMessageOptionsMenu(context, msg),
              child: SwipeToReplyMessageItem(
                msg: msg,
                isFromMe: isFromMe,
                showClipper: isLastFromSameSender,
                onReply: (msg) => widget.onReplyRequested?.call(msg),
                repliedMsg: repliedMsg,
              ),
            );
          },
        ),
        Positioned(
          bottom: 80,
          right: 16,
          child: AnimatedOpacity(
            opacity: _showScrollDownButton ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 200),
            child: FloatingActionButton(
              mini: true,
              backgroundColor: Colors.teal.shade400,
              onPressed: _scrollToBottom,
              child: const Icon(Icons.arrow_downward),
            ),
          ),
        ),
      ],
    );
  }
}
