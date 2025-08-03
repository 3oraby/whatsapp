import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_context_menu/super_context_menu.dart';
import 'package:whatsapp/core/helpers/get_current_user_entity.dart';
import 'package:whatsapp/core/services/time_ago_service.dart';
import 'package:whatsapp/core/widgets/vertical_gap.dart';
import 'package:whatsapp/features/chats/domain/entities/message_entity.dart';
import 'package:whatsapp/features/chats/domain/enums/message_react.dart';
import 'package:whatsapp/features/chats/presentation/cubits/message_stream_cubit/message_stream_cubit.dart';
import 'package:whatsapp/features/chats/presentation/widgets/bubble_message_item.dart';
import 'package:whatsapp/features/chats/presentation/widgets/group_messages_date_header.dart';
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
          ContextMenuWidget(
            hitTestBehavior: HitTestBehavior.opaque,
            previewBuilder: (context, child) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 12,
                ),
                child: Column(
                  crossAxisAlignment: isFromMe
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(60),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: ['❤️', '😂', '👍'].map((react) {
                          final currentUserId = currentUser.id;
                          final hasReact = msg.hasReactFromUser(currentUserId);

                          final MessageReact reactType;
                          if (hasReact) {
                            reactType =
                                msg.getMessageReactType(currentUserId) ??
                                    MessageReact.love;
                          } else {
                            reactType = MessageReactExtension.fromString(react);
                          }

                          final isReactType = hasReact &&
                              MessageReactExtension.getEmojiFromReact(
                                    react: reactType.value,
                                  ) ==
                                  react;
                          return GestureDetector(
                            onTap: () {
                              log("message");
                              BlocProvider.of<MessageStreamCubit>(context)
                                  .emitMessageReaction(
                                messageId: msg.id,
                                reactType: reactType,
                                isCreate: !hasReact,
                              );
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: Container(
                                padding: isReactType
                                    ? const EdgeInsets.all(6)
                                    : const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: isReactType
                                      ? Colors.grey.shade400
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(360),
                                ),
                                child: Text(react,
                                    style: const TextStyle(fontSize: 24)),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const VerticalGap(8),
                    child,
                  ],
                ),
              );
            },
            menuProvider: (MenuRequest menuRequest) {
              return Menu(
                children: [
                  MenuAction(
                    title: 'Reply',
                    image: MenuImage.icon(
                      Icons.reply,
                    ),
                    callback: () {},
                  ),
                  MenuSeparator(),
                  MenuAction(
                    title: 'Copy',
                    image: MenuImage.icon(
                      Icons.copy,
                    ),
                    callback: () {},
                  ),
                  MenuSeparator(),
                  MenuAction(
                    title: 'Edit',
                    image: MenuImage.icon(
                      Icons.edit,
                    ),
                    callback: () {
                      _showEditDialog(context, msg);
                    },
                  ),
                  MenuSeparator(),
                  MenuAction(
                    title: 'Delete',
                    image: MenuImage.icon(
                      Icons.delete,
                    ),
                    attributes: const MenuActionAttributes(destructive: true),
                    callback: () {},
                  ),
                ],
              );
            },
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
