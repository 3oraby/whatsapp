import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/features/chats/domain/repos/socket_repo.dart';
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
      final isOnline = data['status'] == 'online';

      emit(ChatFriendStatusUpdated(
        isOnline: isOnline,
        lastSeen: DateTime.now(),
      ));
    });
  }

  Future<void> _fetchInitialStatus() async {
    final result =
        await userRepo.getUserCurrentStatus(userId: currentChatUserId);
    result.fold(
      (failure) => null,
      (statusEntity) => emit(ChatFriendStatusUpdated(
        isOnline: statusEntity.isOnline,
        lastSeen: statusEntity.lastSeen,
      )),
    );
  }
}
