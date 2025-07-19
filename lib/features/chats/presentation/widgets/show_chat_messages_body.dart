import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/core/cubit/internet/internet_connection_cubit.dart';
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
  late UserEntity currentUser = getCurrentUserEntity()!;
  MessageEntity? _replyMessage;
  late GetChatMessagesCubit getChatMessagesCubit;
  late MessageStreamCubit messageStreamCubit;

  @override
  void initState() {
    super.initState();
    getChatMessagesCubit = context.read<GetChatMessagesCubit>();
    messageStreamCubit = context.read<MessageStreamCubit>();
    messageStreamCubit.resendPendingMessagesForChat(widget.chat.id);
  }

  void sendMessage(String content) {
    final text = content.trim();
    if (text.isEmpty) return;

    final dto = SendMessageDto(
      receiverId: widget.chat.anotherUser.id,
      chatId: widget.chat.id,
      content: text,
      parentId: _replyMessage?.id,
      // createdAt: DateTime.now(),
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
  }

  void _onInternetStateChanged(
      BuildContext context, InternetConnectionState state) {
    if (state is InternetConnectionConnected) {
      debugPrint("_onInternetStateChanged");
      messageStreamCubit.resendPendingMessagesForChat(widget.chat.id);
    }
  }

  void _onMessageStreamChanged(BuildContext context, MessageStreamState state) {
    if (state is NewIncomingMessageState) {
      getChatMessagesCubit.addMessageToList(state.message);
      messageStreamCubit.markMessageAsRead(
        chatId: widget.chat.id,
        messageId: state.message.id,
        senderId: state.message.senderId!,
      );
    } else if (state is NewOutgoingMessageState) {
      getChatMessagesCubit.addMessageToList(state.message);
    } else if (state is UpdateMessageStatusState) {
      if (state.newStatus == MessageStatus.sent) {
        getChatMessagesCubit.updateTempMessage(
          newId: state.newId,
          newStatus: state.newStatus,
        );
      } else {
        getChatMessagesCubit.updateMessageStatus(
          id: state.newId,
          newStatus: state.newStatus,
        );
      }
    } else if (state is EditMessageState) {
      getChatMessagesCubit.editMessage(
        messageId: state.messageId,
        newContent: state.newContent,
        newStatus: MessageStatus.pending,
      );
    } else if (state is MessageEditedSuccessfullyState) {
      getChatMessagesCubit.editMessage(
        messageId: state.messageId,
        newContent: state.newContent,
        newStatus: MessageStatus.read,
      );
    } else if (state is DeleteMessageState ||
        state is MessageDeletedSuccessfullyState) {
      getChatMessagesCubit.deleteMessage(
        messageId: (state as dynamic).messageId,
      );
    } else if (state is CreateNewReactMessageState) {
      getChatMessagesCubit.toggleMessageReact(
        messageId: state.messageId,
        reactType: state.reactType,
        user: currentUser,
        isCreate: true,
      );
    } else if (state is DeleteReactMessageState) {
      getChatMessagesCubit.toggleMessageReact(
        messageId: state.messageId,
        reactType: state.reactType,
        user: currentUser,
        isCreate: false,
      );
    } else if (state is CreateMessageReactSuccessfullyState) {
      getChatMessagesCubit.toggleMessageReact(
        messageId: state.messageReaction.messageId,
        reactType: state.messageReaction.react,
        user: widget.chat.anotherUser,
        isCreate: true,
      );
    } else if (state is DeleteMessageReactSuccessfullyState) {
      getChatMessagesCubit.toggleMessageReact(
        messageId: state.messageReaction.messageId,
        reactType: state.messageReaction.react,
        user: widget.chat.anotherUser,
        isCreate: false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<InternetConnectionCubit, InternetConnectionState>(
          listener: _onInternetStateChanged,
        ),
        BlocListener<MessageStreamCubit, MessageStreamState>(
          listener: _onMessageStreamChanged,
        ),
      ],
      child: SafeArea(
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
              BlocBuilder<MessageStreamCubit, MessageStreamState>(
                buildWhen: (prev, curr) =>
                    curr is UserTypingState || curr is UserStopTypingState,
                builder: (context, state) {
                  final isTyping = state is UserTypingState &&
                      state.chatId == widget.chat.id;

                  return Expanded(
                    child: ShowChatMessagesList(
                      chatId: widget.chat.id,
                      messages: widget.messages,
                      onReplyRequested: _onReplyRequested,
                      isTyping: isTyping,
                    ),
                  );
                },
              ),
              if (_replyMessage != null)
                ReplyToMessageBanner(
                  replyMessage: _replyMessage!,
                  onCancel: () => setState(() => _replyMessage = null),
                ),
              const Divider(height: 1),
              SendMessageSection(
                sendMessage: sendMessage,
                chatId: widget.chat.id,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
