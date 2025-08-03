import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_overlay_menu/smart_overlay_menu.dart';
import 'package:whatsapp/core/helpers/get_current_user_entity.dart';
import 'package:whatsapp/core/services/time_ago_service.dart';
import 'package:whatsapp/core/widgets/vertical_gap.dart';
import 'package:whatsapp/features/chats/domain/entities/message_entity.dart';
import 'package:whatsapp/features/chats/presentation/cubits/message_stream_cubit/message_stream_cubit.dart';
import 'package:whatsapp/features/chats/presentation/widgets/bubble_message_item.dart';
import 'package:whatsapp/features/chats/presentation/widgets/group_messages_date_header.dart';
import 'package:whatsapp/features/chats/presentation/widgets/message_reaction_overlay_menu.dart';
import 'package:whatsapp/features/chats/presentation/widgets/swipe_to_reply_message_item.dart';
import 'package:whatsapp/features/user/domain/entities/user_entity.dart';

class ShowChatMessagesList extends StatefulWidget {
  const ShowChatMessagesList({
    super.key,
    required this.chatId,
    required this.messages,
    this.onReplyRequested,
    this.isTyping = false,
  });

  final int chatId;
  final List<MessageEntity> messages;
  final void Function(MessageEntity message)? onReplyRequested;
  final bool isTyping;

  @override
  State<ShowChatMessagesList> createState() => _ShowChatMessagesListState();
}

class _ShowChatMessagesListState extends State<ShowChatMessagesList> {
  final ScrollController scrollController = ScrollController();
  late UserEntity currentUser;

  bool _showScrollDownButton = false;

  final SmartOverlayMenuController smartOverlayMenuController =
      SmartOverlayMenuController();
  @override
  void initState() {
    super.initState();
    scrollController.addListener(_onScroll);

    currentUser = getCurrentUserEntity()!;
  }

  void _onScroll() {
    if (!scrollController.hasClients) return;

    final offsetFromBottom = scrollController.offset;

    const threshold = 300;

    if (offsetFromBottom > threshold) {
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
    scrollController.removeListener(_onScroll);
    scrollController.dispose();

    super.dispose();
  }

  void _scrollToBottom() {
    if (!scrollController.hasClients) return;

    scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _showEditDialog(BuildContext context, MessageEntity message) {
    final controller = TextEditingController(text: message.content);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit message"),
        content: TextField(controller: controller),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              BlocProvider.of<MessageStreamCubit>(context).emitEditMessage(
                messageId: message.id,
                newContent: controller.text,
              );
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
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
            onTap: () {
              smartOverlayMenuController.open();
            },
            child: SmartOverlayMenu(
              controller: smartOverlayMenuController,
              key: ValueKey(msg.id),
              topWidgetAlignment:
                  isFromMe ? Alignment.centerRight : Alignment.centerLeft,
              bottomWidgetAlignment: Alignment.center,
              topWidget: MessageReactionOverlayMenu(
                currentUser: currentUser,
                msg: msg,
                onReactTap: (reactType, isCreate) {
                  BlocProvider.of<MessageStreamCubit>(context)
                      .emitMessageReaction(
                    messageId: msg.id,
                    reactType: reactType,
                    isCreate: isCreate,
                  );
                  smartOverlayMenuController.close();
                },
              ),
              bottomWidget: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.delete, color: Colors.white),
                    Text('Delete', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
              child: SwipeToReplyMessageItem(
                key: ValueKey(msg.id),
                msg: msg,
                isFromMe: isFromMe,
                showClipper: isLastFromSameSender,
                onReply: (m) => widget.onReplyRequested?.call(m),
                repliedMsg: repliedMsg,
              ),
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
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: const BubbleMessageItem(
            isFromMe: false,
            isTyping: true,
          ),
        ),
      );
    }

    return BlocListener<MessageStreamCubit, MessageStreamState>(
      listener: (context, state) {
        if ((state is UserTypingState && state.chatId == widget.chatId) ||
            state is NewIncomingMessageState ||
            state is NewOutgoingMessageState) {
          _scrollToBottom();
        }
      },
      child: Scrollbar(
        controller: scrollController,
        interactive: true,
        radius: Radius.circular(40),
        thumbVisibility: true,
        trackVisibility: true,
        thickness: 4,
        child: Stack(
          children: [
            ListView(
              controller: scrollController,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              reverse: true,
              children: messageWidgets,
            ),
            Positioned(
              bottom: 60,
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
        ),
      ),
    );
  }
}
