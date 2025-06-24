import 'package:whatsapp/core/cubit/base/base_cubit.dart';
import 'package:whatsapp/features/chats/domain/entities/message_entity.dart';
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
}
