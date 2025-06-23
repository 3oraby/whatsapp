import 'package:flutter/cupertino.dart';
import 'package:whatsapp/core/cubit/base/base_cubit.dart';
import 'package:whatsapp/features/chats/data/models/message_model.dart';
import 'package:whatsapp/features/chats/data/models/send_message_dto.dart';
import 'package:whatsapp/features/chats/domain/entities/message_entity.dart';
import 'package:whatsapp/features/chats/domain/repos/chats_repo.dart';
import 'package:whatsapp/features/chats/domain/repos/socket_repo.dart';

part 'get_chat_messages_state.dart';

class GetChatMessagesCubit extends BaseCubit<GetChatMessagesState> {
  final ChatsRepo chatsRepo;
  final SocketRepo socketRepo;
  GetChatMessagesCubit({
    required this.chatsRepo,
    required this.socketRepo,
  }) : super(GetChatMessagesInitial()) {
    _initSocketListeners();
  }

  void _initSocketListeners() {
    socketRepo.onReceiveMessage((data) {
      debugPrint("receive message in init of GetChatMessagesCubit");
      debugPrint("data: $data");
      final message = MessageModel.fromJson(data).toEntity();

      updateChatOnNewMessage(message);
    });
  }

  void updateChatOnNewMessage(MessageEntity message) {
    final currentState = state;
    if (currentState is! GetChatMessagesLoadedState) return;

    List<MessageEntity> messages =
        (state as GetChatMessagesLoadedState).messages;
    messages.add(message);
    emit(GetChatMessagesLoadedState(messages: messages));
  }

  sendNewMessage({
    required SendMessageDto sendMessageDto,
    required int senderId,
  }) {
    socketRepo.sendMessage(sendMessageDto.toSocketPayload());
    final MessageEntity newMessage = MessageEntity(
      id: -1,
      content: sendMessageDto.content,
      senderId: senderId,
      receiverId: sendMessageDto.receiverId,
      chatId: sendMessageDto.chatId,
      createdAt: DateTime.now(),
      isFromMe: true,
    );

    updateChatOnNewMessage(newMessage);
  }

  Future<void> getChatMessages({
    required int chatId,
  }) async {
    emit(GetChatMessagesLoadingState());

    final result = await chatsRepo.getChatMessages(chatId: chatId);
    result.fold(
      (failure) {
        handleFailure(failure);
        emit(GetChatMessagesFailureState(message: failure.message ?? ''));
      },
      (messages) {
        if (messages.isEmpty) {
          emit(GetChatMessagesEmptyState());
        } else {
          emit(GetChatMessagesLoadedState(messages: messages));
        }
      },
    );
  }
}
