import 'package:whatsapp/core/cubit/base/base_cubit.dart';
import 'package:whatsapp/features/chats/domain/entities/message_entity.dart';
import 'package:whatsapp/features/chats/domain/enums/message_status.dart';
import 'package:whatsapp/features/chats/domain/repos/chats_repo.dart';

part 'get_chat_messages_state.dart';

class GetChatMessagesCubit extends BaseCubit<GetChatMessagesState> {
  final ChatsRepo chatsRepo;
  GetChatMessagesCubit({
    required this.chatsRepo,
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
        if (messages.isEmpty) {
          emit(GetChatMessagesEmptyState());
        } else {
          emit(GetChatMessagesLoadedState(messages: messages));
        }
      },
    );
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

    final idx = messages.indexWhere((msg) => msg.id == -1 && msg.isFromMe);
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
    if (state is! GetChatMessagesLoadedState) return;
    final current = state as GetChatMessagesLoadedState;
    final msgs = List<MessageEntity>.from(current.messages);

    final idx = msgs.indexWhere((m) => m.id == id);
    if (idx == -1) return;

    msgs[idx] = msgs[idx].copyWith(status: newStatus);
    emit(GetChatMessagesLoadedState(messages: msgs));
  }

void markAllMyMessagesAsRead() {
  if (state is! GetChatMessagesLoadedState) return;

  final currentState = state as GetChatMessagesLoadedState;

  final needsUpdate = currentState.messages.any(
    (msg) => msg.isFromMe && msg.status != MessageStatus.read,
  );

  if (!needsUpdate) return;

  final updatedMessages = currentState.messages.map((msg) {
    if (msg.isFromMe && msg.status != MessageStatus.read) {
      return msg.copyWith(status: MessageStatus.read);
    }
    return msg;
  }).toList();

  emit(GetChatMessagesLoadedState(messages: updatedMessages));
}
}
