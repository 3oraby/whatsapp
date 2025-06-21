import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:whatsapp/core/helpers/get_current_user_entity.dart';
import 'package:whatsapp/core/services/get_it_service.dart';
import 'package:whatsapp/features/chats/domain/entities/chat_entity.dart';
import 'package:whatsapp/features/chats/domain/entities/message_entity.dart';
import 'package:whatsapp/features/chats/domain/repos/socket_repo.dart';
import 'package:whatsapp/features/chats/presentation/widgets/send_message_section.dart';
import 'package:whatsapp/features/chats/presentation/widgets/show_chat_messages_list.dart';
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
          child: ShowChatMessagesList(
            scrollController: _scrollController,
            messages: messages,
            currentUser: currentUser,
          ),
        ),
        const Divider(),
        SendMessageSection(
          messageController: _messageController,
          sendMessage: sendMessage,
        ),
      ],
    );
  }
}
