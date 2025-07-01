import 'dart:developer';

import 'package:whatsapp/core/cubit/base/base_cubit.dart';
import 'package:whatsapp/features/chats/data/models/message_model.dart';
import 'package:whatsapp/features/chats/domain/entities/chat_entity.dart';
import 'package:whatsapp/features/chats/domain/entities/last_message_entity.dart';
import 'package:whatsapp/features/chats/domain/entities/message_entity.dart';
import 'package:whatsapp/features/chats/domain/enums/message_status.dart';
import 'package:whatsapp/features/chats/domain/repos/chats_repo.dart';
import 'package:whatsapp/features/chats/domain/repos/socket_repo.dart';

part 'get_user_chats_state.dart';

class GetUserChatsCubit extends BaseCubit<GetUserChatsState> {
  GetUserChatsCubit({
    required this.chatsRepo,
    required this.socketRepo,
  }) : super(GetUserChatsInitial()) {
    _initSocketListeners();
  }

  final ChatsRepo chatsRepo;
  final SocketRepo socketRepo;

  void _initSocketListeners() {
    socketRepo.onReceiveMessage((data) {
      log("receive message in init of GetUserChatsCubit");
      final message = MessageModel.fromJson(data).toEntity();
      updateChatListOnNewMessage(message);
    });
  }

  Future<void> getUserChats() async {
    emit(GetUserChatsLoadingState());
    final result = await chatsRepo.getUserChats();
    result.fold(
      (failure) {
        handleFailure(failure);
        emit(GetUserChatsFailureState(message: failure.message!));
      },
      (chats) {
        if (chats.isEmpty) {
          emit(GetUserChatsEmptyState());
        } else {
          emit(GetUserChatsLoadedState(chats: chats));
        }
      },
    );
  }

  void updateChatListOnNewMessage(MessageEntity message) {
    final currentState = state;
    if (currentState is! GetUserChatsLoadedState) return;

    final isToMe = !message.isFromMe;

    final chats = [...currentState.chats];
    final chatIndex = chats.indexWhere((c) => c.id == message.chatId);

    final LastMessageEntity lastMessageEntity = LastMessageEntity(
      content: message.content,
      messageStatus: message.status,
      createdAt: message.createdAt,
      type: message.type,
      senderId: message.senderId,
      isMine: message.isFromMe,
    );

    ChatEntity updatedChat;

    if (chatIndex != -1) {
      print("chat is founded");
      final oldChat = chats[chatIndex];

      updatedChat = oldChat.copyWith(
        lastMessage: lastMessageEntity,
        unreadCount: isToMe ? oldChat.unreadCount + 1 : oldChat.unreadCount,
      );

      chats.removeAt(chatIndex);
    } else {
      updatedChat = ChatEntity(
        id: message.chatId ?? -1,
        anotherUser: message.sender!,
        isPinned: false,
        unreadCount: isToMe ? 1 : 0,
        isFavorite: false,
        lastMessage: lastMessageEntity,
      );
    }
    chats.insert(0, updatedChat);

    emit(GetUserChatsLoadedState(chats: chats));
  }

  void updateLastMessageStatus({
    required int chatId,
    required MessageStatus newStatus,
  }) {
    final currentState = state;
    if (currentState is! GetUserChatsLoadedState) return;

    final chats = [...currentState.chats];
    final chatIndex = chats.indexWhere((chat) => chat.id == chatId);
    if (chatIndex == -1) return;

    final chat = chats[chatIndex];
    final lastMsg = chat.lastMessage;

    LastMessageEntity updatedLastMsg = lastMsg!.copyWith(
      messageStatus: newStatus,
    );

    final updatedChat = chat.copyWith(
      lastMessage: updatedLastMsg,
    );

    chats[chatIndex] = updatedChat;
    emit(GetUserChatsLoadedState(chats: chats));
  }
}
