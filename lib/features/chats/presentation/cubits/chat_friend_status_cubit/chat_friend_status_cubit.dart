import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/features/chats/domain/repos/socket_repo.dart';
import 'package:whatsapp/features/user/data/models/user_current_status_model.dart';
import 'package:whatsapp/features/user/domain/entities/user_current_status_entity.dart';
import 'package:whatsapp/features/user/domain/repos/user_repo.dart';

part 'chat_friend_status_state.dart';

class ChatFriendStatusCubit extends Cubit<ChatFriendStatusState> {
  final int currentChatUserId;
  final SocketRepo socketRepo;
  final UserRepo userRepo;

  ChatFriendStatusCubit({
    required this.currentChatUserId,
    required this.socketRepo,
    required this.userRepo,
  }) : super(ChatFriendStatusInitial()) {
    _listenToSocket();
    _fetchInitialStatus();
  }

  void _listenToSocket() {
    socketRepo.onFriendStatusUpdate((data) {
      print(data);
      final UserCurrentStatusEntity updatedStatus =
          UserCurrentStatusModel.fromJson(data).toEntity();

      emit(ChatFriendStatusUpdated(updatedStatus));
    });
  }

  Future<void> _fetchInitialStatus() async {
    final result =
        await userRepo.getUserCurrentStatus(userId: currentChatUserId);
    result.fold(
      (failure) => null,
      (statusEntity) => emit(ChatFriendStatusUpdated(statusEntity)),
    );
  }

  UserCurrentStatusEntity? getCurrentFriendStatus(ChatFriendStatusState state) {
    if (state is ChatFriendStatusUpdated) {
      return state.status;
    }
    return null;
  }
}
