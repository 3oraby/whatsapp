import 'package:whatsapp/core/cubit/base/base_cubit.dart';
import 'package:whatsapp/features/chats/domain/entities/chat_entity.dart';
import 'package:whatsapp/features/chats/domain/repos/chats_repo.dart';

part 'get_user_chats_state.dart';

class GetUserChatsCubit extends BaseCubit<GetUserChatsState> {
  GetUserChatsCubit({required this.chatsRepo})
      : super(GetUserChatsInitial());

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
}
