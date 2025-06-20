import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:whatsapp/core/helpers/get_current_user_entity.dart';
import 'package:whatsapp/core/services/get_it_service.dart';
import 'package:whatsapp/core/utils/app_colors.dart';
import 'package:whatsapp/core/utils/app_text_styles.dart';
import 'package:whatsapp/core/widgets/build_user_profile_image.dart';
import 'package:whatsapp/core/widgets/horizontal_gap.dart';
import 'package:whatsapp/features/chats/domain/entities/chat_entity.dart';
import 'package:whatsapp/features/chats/domain/entities/message_entity.dart';
import 'package:whatsapp/features/chats/domain/repos/socket_repo.dart';
import 'package:whatsapp/features/user/domain/user_entity.dart';

class ChatScreen extends StatefulWidget {
  final ChatEntity chat;

  const ChatScreen({super.key, required this.chat});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late List<MessageEntity> messages;
  late UserEntity currentUser = getCurrentUserEntity();

  @override
  void initState() {
    super.initState();
    messages = List.from(widget.chat.messages);
    _initSocketConnection();
  }

  void _initSocketConnection() async {
    getIt<SocketRepo>().onReceiveMessage((data) {
      if (data["chat_id"] == widget.chat.id) {
        log('receive message done');

        setState(() {
          messages.add(
            MessageEntity(
              id: data["id"] ?? 0,
              content: data["content"] ?? '',
              senderId: data["user_id"], // ده هو الـ sender
              receiverId: data["reciever_id"],
              chatId: data["chat_id"],
              createdAt: DateTime.parse(data["createdAt"]),
              status: data["status"] ?? 'sent',
              type: data["type"] ?? 'text',
              mediaUrl: data["media_url"],
              parentId: data["parent_id"],
              isDeleted: data["isDeleted"] ?? false,
              statusId: data["statusId"],
              updatedAt: data["updatedAt"] != null
                  ? DateTime.parse(data["updatedAt"])
                  : null,
            ),
          );
        });

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
      setState(() {
        messages.add(
          MessageEntity(
            id: 0,
            content: text,
            senderId: currentUser.id,
            receiverId: widget.chat.anotherUser.id,
            chatId: widget.chat.id,
            createdAt: DateTime.now(),
            status: 'sent',
            type: 'text',
          ),
        );
        _messageController.clear();
      });

      _scrollToBottom();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(child: _buildMessageList()),
          const Divider(height: 1),
          _buildMessageInput(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    final user = widget.chat.anotherUser;
    return AppBar(
      backgroundColor: AppColors.primary,
      leading: const BackButton(color: Colors.white),
      title: Row(
        children: [
          BuildUserProfileImage(
            profilePicUrl: user.profileImage,
            circleAvatarRadius: 16,
          ),
          const HorizontalGap(10),
          Text(
            user.name,
            style: AppTextStyles.poppinsMedium(context, 18)
                .copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final msg = messages[index];
        final isMe =
            msg.senderId == currentUser.id; // replace with auth ID check

        return Align(
          alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
            margin: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              color: isMe
                  ? AppColors.primary.withOpacity(0.9)
                  : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              msg.content ?? "content",
              style: TextStyle(
                color: isMe ? Colors.white : Colors.black,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMessageInput() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        color: Colors.grey.shade100,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                decoration: const InputDecoration(
                  hintText: "Type a message",
                  border: InputBorder.none,
                ),
                onSubmitted: (_) => sendMessage(),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send, color: AppColors.primary),
              onPressed: sendMessage,
            ),
          ],
        ),
      ),
    );
  }
}
