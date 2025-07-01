import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/core/helpers/get_current_user_entity.dart';
import 'package:whatsapp/core/utils/app_images.dart';
import 'package:whatsapp/features/chats/data/models/send_message_dto.dart';
import 'package:whatsapp/features/chats/domain/entities/chat_entity.dart';
import 'package:whatsapp/features/chats/domain/entities/message_entity.dart';
import 'package:whatsapp/features/chats/domain/enums/message_status.dart';
import 'package:whatsapp/features/chats/presentation/cubits/get_chat_messages_cubit/get_chat_messages_cubit.dart';
import 'package:whatsapp/features/chats/presentation/cubits/message_stream_cubit/message_stream_cubit.dart';
import 'package:whatsapp/features/chats/presentation/widgets/reply_to_message_banner.dart';
import 'package:whatsapp/features/chats/presentation/widgets/send_message_section.dart';
import 'package:whatsapp/features/chats/presentation/widgets/show_chat_messages_list.dart';
import 'package:whatsapp/features/user/domain/entities/user_entity.dart';

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
  late UserEntity currentUser = getCurrentUserEntity();
  MessageEntity? _replyMessage;
  late GetChatMessagesCubit getChatMessagesCubit;
  late MessageStreamCubit messageStreamCubit;

  @override
  void initState() {
    super.initState();
    getChatMessagesCubit = context.read<GetChatMessagesCubit>();
    messageStreamCubit = context.read<MessageStreamCubit>();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(
          _scrollController.position.maxScrollExtent,
        );
      }
    });
  }

  void sendMessage(String content) {
    final text = content.trim();
    if (text.isEmpty) return;

    final dto = SendMessageDto(
      receiverId: widget.chat.anotherUser.id,
      chatId: widget.chat.id,
      content: text,
      parentId: _replyMessage?.id,
    );

    messageStreamCubit.sendMessage(
          dto: dto,
          currentUserId: currentUser.id,
        );

    setState(() {
      _replyMessage = null;
    });
  }

  void _onReplyRequested(MessageEntity message) {
    setState(() {
      _replyMessage = message;
    });
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<MessageStreamCubit, MessageStreamState>(
          listener: (context, state) {
            if (state is NewIncomingMessageState) {
              final message = state.message;
              getChatMessagesCubit.addMessageToList(message);
              messageStreamCubit.markMessageAsRead(
                chatId: widget.chat.id,
                messageId: message.id,
                senderId: message.senderId,
              );
            }
            if (state is NewOutgoingMessageState) {
              getChatMessagesCubit.addMessageToList(state.message);
            }
            if (state is UpdateMessageStatusState) {
              final messageId = state.newId;
              final newStatus = state.newStatus;
              if (newStatus == MessageStatus.sent) {
                getChatMessagesCubit.updateTempMessage(
                  newId: messageId,
                  newStatus: newStatus,
                );
              } else {
                getChatMessagesCubit.updateMessageStatus(
                  id: messageId,
                  newStatus: newStatus,
                );
              }
            }
          },
        ),
        BlocListener<GetChatMessagesCubit, GetChatMessagesState>(
          listener: (context, state) {
            if (state is GetChatMessagesLoadedState) {
              _scrollToBottom();
            }
          },
        ),
      ],
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppImages.imagesWhatsappWallpaper8),
            fit: BoxFit.cover,
            filterQuality: FilterQuality.low,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: ShowChatMessagesList(
                scrollController: _scrollController,
                messages: widget.messages,
                onReplyRequested: _onReplyRequested,
              ),
            ),
            if (_replyMessage != null)
              ReplyToMessageBanner(
                replyMessage: _replyMessage!,
                onCancel: () => setState(
                  () => _replyMessage = null,
                ),
              ),
            const Divider(height: 1),
            SendMessageSection(
              sendMessage: sendMessage,
            ),
          ],
        ),
      ),
    );
  }
}
