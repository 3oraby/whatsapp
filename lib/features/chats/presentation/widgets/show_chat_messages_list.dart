import 'package:flutter/material.dart';
import 'package:whatsapp/core/services/time_ago_service.dart';
import 'package:whatsapp/core/widgets/vertical_gap.dart';
import 'package:whatsapp/features/chats/domain/entities/message_entity.dart';
import 'package:whatsapp/features/chats/presentation/widgets/bubble_message_item.dart';
import 'package:whatsapp/features/chats/presentation/widgets/group_messages_date_header.dart';
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
    final groupedMessages = <String, List<MessageEntity>>{};

    for (var message in widget.messages) {
      final groupKey = TimeAgoService.groupTitleFromDate(message.createdAt);
      groupedMessages.putIfAbsent(groupKey, () => []).add(message);
    }

    final messageWidgets = <Widget>[];

    final reversedGroups = groupedMessages.entries.toList().reversed;

    for (var group in reversedGroups) {
      final dateTitle = group.key;
      final messages = group.value.reversed.toList();

      for (int i = 0; i < messages.length; i++) {
        final msg = messages[i];
        final isFromMe = msg.isFromMe;
        final isLastFromSameSender =
            i == 0 || messages[i - 1].senderId != msg.senderId;

        final isReplied = msg.parentId != null;
        MessageEntity? repliedMsg;
        if (isReplied) {
          repliedMsg = widget.messages.firstWhere(
            (m) => m.id == msg.parentId,
            orElse: () => msg,
          );
        }

        messageWidgets.add(
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onLongPress: () => showMessageOptionsMenu(context, msg),
            child: SwipeToReplyMessageItem(
              msg: msg,
              isFromMe: isFromMe,
              showClipper: isLastFromSameSender,
              onReply: (m) => widget.onReplyRequested?.call(m),
              repliedMsg: repliedMsg,
            ),
          ),
        );
        messageWidgets.add(const VerticalGap(8));
      }
      messageWidgets.add(GroupMessagesDateHeader(label: dateTitle));
    }

    if (widget.isTyping) {
      messageWidgets.insert(
        0,
        const BubbleMessageItem(
          isFromMe: false,
          isTyping: true,
        ),
      );
    }

    return Stack(
      children: [
        ListView(
          controller: widget.scrollController,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          reverse: true,
          children: messageWidgets,
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
