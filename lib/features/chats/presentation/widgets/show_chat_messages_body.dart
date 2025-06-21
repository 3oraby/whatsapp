import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:whatsapp/core/helpers/get_current_user_entity.dart';
import 'package:whatsapp/core/services/get_it_service.dart';
import 'package:whatsapp/core/services/time_ago_service.dart';
import 'package:whatsapp/core/utils/app_colors.dart';
import 'package:whatsapp/core/utils/app_text_styles.dart';
import 'package:whatsapp/features/chats/domain/entities/chat_entity.dart';
import 'package:whatsapp/features/chats/domain/entities/message_entity.dart';
import 'package:whatsapp/features/chats/domain/repos/socket_repo.dart';
import 'package:whatsapp/features/user/domain/user_entity.dart';

class ShowChatMessagesBody extends StatefulWidget {
  final List<MessageEntity> messages;
  final ChatEntity chat;

  const ShowChatMessagesBody({
    super.key,
    required this.messages,
    required this.chat,
  });

  @override
  State<ShowChatMessagesBody> createState() => _ShowChatMessagesBodyState();
}

class _ShowChatMessagesBodyState extends State<ShowChatMessagesBody> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late List<MessageEntity> messages;
  late UserEntity currentUser = getCurrentUserEntity();

  @override
  void initState() {
    super.initState();
    messages = widget.messages;
    _initSocketConnection();
  }

  void _initSocketConnection() async {
    getIt<SocketRepo>().onReceiveMessage((data) {
      if (data["chat_id"] == widget.chat.id) {
        log('receive message done');

        // setState(() {
        //   messages.add(
        //     MessageEntity(
        //       id: data["id"] ?? 0,
        //       content: data["content"] ?? '',
        //       senderId: data["user_id"], // ده هو الـ sender
        //       receiverId: data["reciever_id"],
        //       chatId: data["chat_id"],
        //       createdAt: DateTime.parse(data["createdAt"]),
        //       status: data["status"] ?? 'sent',
        //       type: data["type"] ?? 'text',
        //       mediaUrl: data["media_url"],
        //       parentId: data["parent_id"],
        //       isDeleted: data["isDeleted"] ?? false,
        //       statusId: data["statusId"],
        //       updatedAt: data["updatedAt"] != null
        //           ? DateTime.parse(data["updatedAt"])
        //           : null,
        //     ),
        //   );
        // });

        _scrollToBottom();
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  void sendMessage() {
    final text = _messageController.text.trim();

    if (text.isNotEmpty) {
      log(text);
      // final messageData = {
      //   "chatId": widget.chat.id,
      //   "receiverId": widget.chat.anotherUser.id,
      //   "message": text,
      //   "createdAt": DateTime.now().toIso8601String(),
      //   "senderId": currentUser.id,
      // };
      final messageData = {
        "receiverId": widget.chat.anotherUser.id,
        "message": {
          "content": text,
          "chatId": widget.chat.id,
          "parent_id": null,
          "statusId": null,
          "type": "text",
          "media_url": null,
        }
      };
      getIt<SocketRepo>().sendMessage(messageData);

      log("Sent message: $messageData");
      // setState(() {
      //   messages.add(
      //     MessageEntity(
      //       id: 0,
      //       content: text,
      //       senderId: currentUser.id,
      //       receiverId: widget.chat.anotherUser.id,
      //       chatId: widget.chat.id,
      //       createdAt: DateTime.now(),
      //       status: 'sent',
      //       type: 'text',
      //     ),
      //   );
      //   _messageController.clear();
      // });

      _scrollToBottom();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(),
        Expanded(
          child: _buildMessageList(),
        ),
        const Divider(),
        _buildMessageInput(),
      ],
    );
  }

  Widget _buildMessageList() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 16,
      ),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final msg = messages[index];
        final isFromMe = msg.senderId == currentUser.id;

        return Align(
          alignment: isFromMe ? Alignment.centerRight : Alignment.centerLeft,
          child: CustomBubbleMessageItem(
            isFromMe: isFromMe,
            msg: msg,
          ),
        );
      },
    );
  }

  Widget _buildMessageInput() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _messageController,
                  style: const TextStyle(color: Colors.black87),
                  decoration: const InputDecoration(
                    hintText: "Type a message",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                  ),
                  onSubmitted: (_) => sendMessage(),
                ),
              ),
              const SizedBox(width: 6),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary,
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.send,
                    color: Colors.white,
                  ),
                  onPressed: sendMessage,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomBubbleMessageItem extends StatelessWidget {
  const CustomBubbleMessageItem({
    super.key,
    required this.isFromMe,
    required this.msg,
  });

  final bool isFromMe;
  final MessageEntity msg;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    return Align(
      alignment: isFromMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: screenWidth / 2,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        decoration: BoxDecoration(
          color: isFromMe ? AppColors.myMessageLight : Colors.grey.shade100,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(12),
            topRight: const Radius.circular(12),
            bottomLeft: Radius.circular(isFromMe ? 12 : 0),
            bottomRight: Radius.circular(isFromMe ? 0 : 12),
          ),
        ),
        child: Column(
          crossAxisAlignment:
              isFromMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              msg.content ?? "content",
              style: AppTextStyles.poppinsMedium(context, 16),
            ),
            const SizedBox(height: 4),
            Text(
              TimeAgoService.formatTimeOnly(msg.createdAt),
              style: AppTextStyles.poppinsMedium(context, 12).copyWith(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
