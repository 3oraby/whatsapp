import 'package:flutter/foundation.dart';
import 'package:whatsapp/core/cubit/base/base_cubit.dart';
import 'package:whatsapp/features/chats/domain/entities/chat_entity.dart';
import 'package:whatsapp/features/chats/domain/entities/last_message_entity.dart';
import 'package:whatsapp/features/chats/domain/entities/message_entity.dart';
import 'package:whatsapp/features/chats/domain/enums/message_status.dart';
import 'package:whatsapp/features/chats/domain/repos/chats_repo.dart';

part 'get_user_chats_state.dart';

class GetUserChatsCubit extends BaseCubit<GetUserChatsState> {
  GetUserChatsCubit({
    required this.chatsRepo,
  }) : super(GetUserChatsInitial());
  final ChatsRepo chatsRepo;

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

  int _findChatIndex(List<ChatEntity> chats, int chatId) =>
      chats.indexWhere((c) => c.id == chatId);

  int _findChatByLastMessageId(List<ChatEntity> chats, int messageId) =>
      chats.indexWhere((c) => c.lastMessage?.messageId == messageId);

  void updateChatListOnNewMessage(MessageEntity message) {
    final currentState = state;
    if (currentState is! GetUserChatsLoadedState) return;

    final isToMe = !message.isFromMe;

    final chats = [...currentState.chats];
    final chatIndex = chats.indexWhere((c) => c.id == message.chatId);

    final LastMessageEntity lastMessageEntity = LastMessageEntity(
      messageId: message.id,
      content: message.content,
      messageStatus: message.status,
      createdAt: message.createdAt,
      type: message.type,
      senderId: message.senderId,
      isMine: message.isFromMe,
    );

    ChatEntity updatedChat;

    if (chatIndex != -1) {
      debugPrint("chat is founded");
      final oldChat = chats[chatIndex];

      debugPrint(message.status.value);
      updatedChat = oldChat.copyWith(
        lastMessage: lastMessageEntity,
        unreadCount: isToMe
            ? oldChat.unreadCount + 1
            : oldChat.unreadCount,
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
    required int messageId,
    required MessageStatus newStatus,
  }) {
    debugPrint("update last message:: id = $messageId  with status: $newStatus in getUserChatsCubit");
    final currentState = state;
    if (currentState is! GetUserChatsLoadedState) return;

    final chats = [...currentState.chats];
    final chatIndex = _findChatIndex(chats, chatId);
    if (chatIndex == -1) return;

    final chat = chats[chatIndex];
    final lastMsg = chat.lastMessage;

    if (lastMsg == null) {
      debugPrint(
          "there is no last message to update: in GetUserChatsCubit.updateLastMessageStatus()");
      return;
    }
    LastMessageEntity updatedLastMsg = lastMsg.copyWith(
      messageStatus: newStatus,
    );

    final updatedChat = chat.copyWith(
      lastMessage: updatedLastMsg,
    );

    chats[chatIndex] = updatedChat;
    emit(GetUserChatsLoadedState(chats: chats));
  }

  void updateLastMessageAsSeen({required int chatId}) {
    final currentState = state;
    if (currentState is! GetUserChatsLoadedState) return;

    final chats = [...currentState.chats];
    final chatIndex = _findChatIndex(chats, chatId);

    if (chatIndex == -1) return;

    final chat = chats[chatIndex];
    final updatedChat = chat.copyWith(
      unreadCount: 0,
    );

    chats[chatIndex] = updatedChat;
    emit(GetUserChatsLoadedState(chats: chats));
  }

  void updateLastMessageOnEditMessage({
    required int messageId,
    required String newContent,
  }) {
    final currentState = state;
    if (currentState is! GetUserChatsLoadedState) return;

    final chats = [...currentState.chats];
    final chatIndex = _findChatByLastMessageId(chats, messageId);
    if (chatIndex == -1) return;

    final chat = chats[chatIndex];
    final lastMsg = chat.lastMessage;

    LastMessageEntity updatedLastMsg = lastMsg!.copyWith(
      content: newContent,
    );

    final updatedChat = chat.copyWith(
      lastMessage: updatedLastMsg,
    );
    chats.removeAt(chatIndex);
    chats.insert(0, updatedChat);
    emit(GetUserChatsLoadedState(chats: chats));
  }

  void updateLastMessageOnDeleteMessage({
    required int messageId,
  }) {
    final currentState = state;
    if (currentState is! GetUserChatsLoadedState) return;

    final chats = [...currentState.chats];
    final chatIndex = _findChatByLastMessageId(chats, messageId);
    if (chatIndex == -1) return;

    final chat = chats[chatIndex];
    final lastMsg = chat.lastMessage;
    LastMessageEntity updatedLastMsg = lastMsg!.copyWith(
      content: null,
      messageStatus: null,
      isDeleted: true,
    );

    final updatedChat = chat.copyWith(
      lastMessage: updatedLastMsg,
    );
    chats.removeAt(chatIndex);
    chats.insert(0, updatedChat);
    emit(GetUserChatsLoadedState(chats: chats));
  }
}
