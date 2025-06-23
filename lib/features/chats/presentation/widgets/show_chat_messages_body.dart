import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/core/helpers/get_current_user_entity.dart';
import 'package:whatsapp/features/chats/data/models/send_message_dto.dart';
import 'package:whatsapp/features/chats/domain/entities/chat_entity.dart';
import 'package:whatsapp/features/chats/domain/entities/message_entity.dart';
import 'package:whatsapp/features/chats/presentation/cubits/get_chat_messages_cubit/get_chat_messages_cubit.dart';
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
  final ScrollController _scrollController = ScrollController();
  late List<MessageEntity> messages;
  late UserEntity currentUser = getCurrentUserEntity();

  @override
  void initState() {
    super.initState();
    messages = widget.messages;
  }

  @override
  void dispose() {
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

  void sendMessage(String content) {
    final text = content.trim();
    log("new message content: $text");
    if (text.isNotEmpty) {
      final SendMessageDto sendMessageDto = SendMessageDto(
        receiverId: widget.chat.anotherUser.id,
        chatId: widget.chat.id,
        content: content,
      );
      BlocProvider.of<GetChatMessagesCubit>(context).sendNewMessage(
        sendMessageDto: sendMessageDto,
        senderId: currentUser.id,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GetChatMessagesCubit,GetChatMessagesState>(
      listener: (context, state) {
        if (state is GetChatMessagesLoadedState){
          _scrollToBottom();
        }
      },
      child: Column(
        children: [
          const Divider(),
          Expanded(
            child: ShowChatMessagesList(
              scrollController: _scrollController,
              messages: messages,
              currentUser: currentUser,
            ),
          ),
          SendMessageSection(
            sendMessage: (content) => sendMessage(content),
          ),
        ],
      ),
    );
  }
}
