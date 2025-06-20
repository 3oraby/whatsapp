import 'package:whatsapp/core/cubit/base/base_cubit.dart';
import 'package:whatsapp/features/chats/domain/entities/chat_entity.dart';
import 'package:whatsapp/features/chats/domain/entities/message_entity.dart';
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
      final chatId = data['chat_id'];

      final message = MessageEntity(
        id: data["id"],
        content: data["content"],
        chatId: chatId,
        senderId: data["user_id"],
        receiverId: data["reciever_id"],
        type: data["type"] ?? "text",
        createdAt: DateTime.parse(data["createdAt"]),
        status: data["status"] ?? "sent",
      );

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
  //   final currentState = state;
  //   if (currentState is! GetUserChatsLoadedState) return;

  //   final currentUserId = getCurrentUserEntity().id;
  //   final isFromMe = message.senderId == currentUserId;
  //   final isToMe = message.receiverId == currentUserId;

  //   final chats = [...currentState.chats];
  //   final chatIndex = chats.indexWhere((c) => c.id == message.chatId);

  //   ChatEntity updatedChat;

  //   if (chatIndex != -1) {
  //     // ✅ الشات موجود بالفعل
  //     final oldChat = chats[chatIndex];

  //     updatedChat = oldChat.copyWith(
  //       messages: [...oldChat.messages, message],
  //       lastMessageCreatedAt: message.createdAt,
  //       unreadCount: isToMe ? oldChat.unreadCount + 1 : oldChat.unreadCount,
  //     );

  //     chats.removeAt(chatIndex); // هنحركه لفوق
  //   } else {
  //     // ✅ شات جديد
  //     final anotherUser = isFromMe
  //         ? ChatUserEntity(
  //             id: message.receiverId,
  //             name: message.receiverName ?? 'Unknown',
  //             image: message.receiverImage ?? '',
  //           )
  //         : ChatUserEntity(
  //             id: message.senderId,
  //             name: message.senderName ?? 'Unknown',
  //             image: message.senderImage ?? '',
  //           );

  //     updatedChat = ChatEntity(
  //       id: message.chatId,
  //       type: "personal",
  //       anotherUser: anotherUser,
  //       isPinned: false,
  //       pinnedAt: null,
  //       lastMessageCreatedAt: message.createdAt,
  //       messages: [message],
  //       unreadCount: isToMe ? 1 : 0,
  //     );
  //   }

  //   // ✅ ضيف الشات بعد التحديث على أول الليست
  //   chats.insert(0, updatedChat);

  //   // ✅ لو في pinning system، ضيف ترتيب لاحقًا
  //   emit(GetUserChatsLoadedState(chats: chats));
  }
}
