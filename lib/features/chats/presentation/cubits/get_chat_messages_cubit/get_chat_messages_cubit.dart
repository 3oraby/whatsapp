import 'package:flutter/rendering.dart';
import 'package:whatsapp/core/cubit/base/base_cubit.dart';
import 'package:whatsapp/core/helpers/pending_messages/pending_message_helper.dart';
import 'package:whatsapp/features/chats/data/models/message_model.dart';
import 'package:whatsapp/features/chats/data/models/send_message_dto.dart';
import 'package:whatsapp/features/chats/domain/entities/message_entity.dart';
import 'package:whatsapp/features/chats/domain/entities/message_reaction_info.dart';
import 'package:whatsapp/features/chats/domain/enums/message_react.dart';
import 'package:whatsapp/features/chats/domain/enums/message_status.dart';
import 'package:whatsapp/features/chats/domain/repos/chats_repo.dart';
import 'package:whatsapp/features/user/domain/entities/user_entity.dart';

part 'get_chat_messages_state.dart';

class GetChatMessagesCubit extends BaseCubit<GetChatMessagesState> {
  final ChatsRepo chatsRepo;
  final PendingMessagesHelper pendingMessagesHelper;
  GetChatMessagesCubit({
    required this.chatsRepo,
    required this.pendingMessagesHelper,
  }) : super(GetChatMessagesInitial());

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
        emit(GetChatMessagesLoadedState(messages: messages));
      },
    );
  }

  void loadPendingMessages({
    required int chatId,
    required int currentUserId,
  }) async {
    final pending = await pendingMessagesHelper.getPendingMessages();
    final List chatPending =
        pending.where((m) => m['chatId'] == chatId).toList();
    if (chatPending.isEmpty) {
      debugPrint("there is no pending messages in this chat: $chatId");
      return;
    }
    for (final msg in chatPending) {
      final messageDto = SendMessageDto.fromJson(msg);
      final tempMessage = MessageEntity.fromDto(messageDto, currentUserId);

      addMessageToList(tempMessage);
    }
  }

  void addMessageToList(MessageEntity message) {
    final currentState = state;
    if (currentState is GetChatMessagesLoadedState) {
      final updatedMessages = List<MessageEntity>.from(currentState.messages)
        ..add(message);
      emit(GetChatMessagesLoadedState(messages: updatedMessages));
    }
  }

  void updateTempMessage({
    required int newId,
    required MessageStatus newStatus,
  }) {
    if (state is! GetChatMessagesLoadedState) return;
    final currentState = state as GetChatMessagesLoadedState;
    final messages = List<MessageEntity>.from(currentState.messages);

    final pendingMessages =
        messages.where((msg) => msg.id == -1 && msg.isFromMe).toList();

    if (pendingMessages.isEmpty) return;

    pendingMessages.sort((a, b) => a.createdAt.compareTo(b.createdAt));

    final oldestPendingMessage = pendingMessages.first;

    final idx = messages.indexOf(oldestPendingMessage);
    if (idx == -1) return;
    messages[idx] = messages[idx].copyWith(
      id: newId,
      status: newStatus,
    );

    emit(GetChatMessagesLoadedState(messages: messages));
  }

  void updateMessageStatus({
    required int id,
    required MessageStatus newStatus,
  }) {
    debugPrint(
        "in GetChatMessagesCubit: update message: $id with new status : ${newStatus.value}");
    if (state is! GetChatMessagesLoadedState) return;
    final current = state as GetChatMessagesLoadedState;
    final msgs = List<MessageEntity>.from(current.messages);
    debugPrint("last message: ${msgs.last.id}");

    final idx = msgs.indexWhere((m) => m.id == id);
    if (idx == -1) return;

    msgs[idx] = msgs[idx].copyWith(status: newStatus);
    emit(GetChatMessagesLoadedState(messages: msgs));
  }

  void editMessage({
    required int messageId,
    required String newContent,
    required MessageStatus newStatus,
  }) {
    if (state is! GetChatMessagesLoadedState) return;
    final current = state as GetChatMessagesLoadedState;
    final msgs = List<MessageEntity>.from(current.messages);

    final idx = msgs.indexWhere((m) => m.id == messageId);
    if (idx == -1) return;

    msgs[idx] = msgs[idx].copyWith(
      content: newContent,
      updatedAt: DateTime.now(),
      isEdited: true,
      status: msgs[idx].isFromMe ? null : newStatus,
    );

    emit(GetChatMessagesLoadedState(messages: msgs));
  }

  void deleteMessage({
    required int messageId,
  }) {
    if (state is! GetChatMessagesLoadedState) return;
    final current = state as GetChatMessagesLoadedState;
    final msgs = List<MessageEntity>.from(current.messages);

    final idx = msgs.indexWhere((m) => m.id == messageId);
    if (idx == -1) return;

    msgs[idx] = msgs[idx].copyWith(
      content: null,
      mediaUrl: null,
      isEdited: false,
      isDeleted: true,
      status: null,
    );

    emit(GetChatMessagesLoadedState(messages: msgs));
  }

  void toggleMessageReact({
    required int messageId,
    required MessageReact reactType,
    required bool isCreate,
    required UserEntity user,
  }) {
    if (state is! GetChatMessagesLoadedState) return;
    final current = state as GetChatMessagesLoadedState;
    final msgs = List<MessageEntity>.from(current.messages);

    final idx = msgs.indexWhere((m) => m.id == messageId);
    if (idx == -1) return;

    final msg = msgs[idx];
    final reacts = List.of(msg.reacts);

    if (isCreate) {
      MessageReactionInfo? existingReact;
      try {
        existingReact = reacts.firstWhere((r) => r.user.id == user.id);
      } catch (e) {
        existingReact = null;
      }

      if (existingReact != null) {
        reacts.remove(existingReact);
      }

      reacts.add(
        MessageReactionInfo(
          id: DateTime.now().millisecondsSinceEpoch,
          createdAt: DateTime.now(),
          user: user,
          messageReact: reactType,
        ),
      );
    } else {
      reacts.removeWhere((r) => r.user.id == user.id);
    }
    msgs[idx] = msg.copyWith(
      reactsCount: isCreate ? msg.reactsCount + 1 : msg.reactsCount - 1,
      reacts: reacts,
    );
    debugPrint(MessageModel.fromEntity(msgs[idx]).toJson().toString());

    emit(GetChatMessagesLoadedState(messages: msgs));
  }
}
