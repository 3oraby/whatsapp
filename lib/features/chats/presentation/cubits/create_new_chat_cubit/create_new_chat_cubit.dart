import 'package:whatsapp/core/cubit/base/base_cubit.dart';
import 'package:whatsapp/features/chats/domain/entities/chat_entity.dart';
import 'package:whatsapp/features/chats/domain/repos/chats_repo.dart';
import 'package:whatsapp/features/user/domain/entities/user_entity.dart';

part 'create_new_chat_state.dart';

class CreateNewChatCubit extends BaseCubit<CreateNewChatState> {
  CreateNewChatCubit({
    required this.chatsRepo,
  }) : super(CreateNewChatInitial());

  final ChatsRepo chatsRepo;

  Future<void> createNewChat({
    String type = "chat",
    required UserEntity anotherUser,
  }) async {
    emit(CreateNewChatLoadingState());
    final result = await chatsRepo.createNewChat(
      type: type,
      anotherUser: anotherUser,
    );
    result.fold(
      (failure) {
        handleFailure(failure);
        emit(CreateNewChatFailureState(message: failure.message!));
      },
      (chat) {
        emit(CreateNewChatLoadedState(chat: chat));
      },
    );
  }
}
