import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/features/chats/data/models/message_model.dart';
import 'package:whatsapp/features/chats/data/models/send_message_dto.dart';
import 'package:whatsapp/features/chats/domain/entities/message_entity.dart';
import 'package:whatsapp/features/chats/domain/enums/message_react.dart';
import 'package:whatsapp/features/chats/domain/enums/message_status.dart';
import 'package:whatsapp/features/chats/domain/repos/socket_repo.dart';

part 'message_stream_state.dart';

class MessageStreamCubit extends Cubit<MessageStreamState> {
  final SocketRepo socketRepo;

  MessageStreamCubit({required this.socketRepo})
      : super(MessageStreamInitial()) {
    _initSocketListeners();
  }

  void _initSocketListeners() {
    socketRepo.onReceiveMessage((data) {
      debugPrint("✅ New message: $data");
      final message = MessageModel.fromJson(data).toEntity();
      if (!isClosed) {
        emit(NewIncomingMessageState(message));
      }
    });

    socketRepo.onMessageStatusUpdate((data) {
      debugPrint(data.toString());
      final messageId = data["messageId"];
      final newStatus = (data["status"] as String).toMessageStatus();
      final int chatId = data['chatId'];

      if (!isClosed) {
        emit(UpdateMessageStatusState(
          chatId: chatId,
          newId: messageId,
          newStatus: newStatus,
        ));
      }
    });

    socketRepo.onMessageRead((data) {
      debugPrint(data.toString());
      final int messageId = data['messageId'];
      final int chatId = data['chatId'];
      if (!isClosed) {
        emit(UpdateMessageStatusState(
          chatId: chatId,
          newId: messageId,
          newStatus: MessageStatus.read,
        ));
      }
    });

    socketRepo.onAllMessagesRead((data) {
      debugPrint(data.toString());
      final chatId = data["chatId"];
      if (!isClosed) {
        emit(AllMessagesReadState(chatId: chatId));
      }
    });

    socketRepo.onTyping((data) {
      debugPrint("onTyping: ${data.toString()}");
      final int senderId = data["from"];
      final int chatId = data["chatId"];

      if (!isClosed) {
        emit(UserTypingState(chatId: chatId, senderId: senderId));
      }
    });

    socketRepo.onStopTyping((data) {
      debugPrint("onStopTyping: ${data.toString()}");
      final int senderId = data["from"];
      final int chatId = data["chatId"];

      if (!isClosed) {
        emit(UserStopTypingState(chatId: chatId, senderId: senderId));
      }
    });

    socketRepo.onEditMessage(
      (data) {
        debugPrint("✏️ message edited: $data");
        final messageId = data['messageId'];
        final newContent = data['content'];
        if (!isClosed) {
          emit(MessageEditedSuccessfullyState(
            messageId: messageId,
            newContent: newContent,
          ));
        }
      },
    );

    socketRepo.onMessageEditedSuccessfully((data) {
      debugPrint("✏️ message edited: $data");
      final messageId = data["messageId"];
      final newContent = data['content'];

      if (!isClosed) {
        emit(MessageEditedSuccessfullyState(
          messageId: messageId,
          newContent: newContent,
        ));
      }
    });

    socketRepo.onDeleteMessage((data) {
      debugPrint("🗑 Deleted: $data");
      final int messageId = data["messageId"];

      if (!isClosed) {
        emit(MessageDeletedSuccessfullyState(
          messageId: messageId,
        ));
      }
    });

    socketRepo.onMessageDeletedSuccessfully((data) {
      debugPrint("🗑 Deleted: $data");
      final int messageId = data["messageId"];

      if (!isClosed) {
        emit(MessageDeletedSuccessfullyState(
          messageId: messageId,
        ));
      }
    });

    socketRepo.onMessageReactedSuccessfully((data) {
      debugPrint("❤️ Reacted: $data");
      final int messageId = data["messageId"];
      final int chatId = data["chatId"];
      final int reactsCount = data["reactsCount"];

      if (!isClosed) {
        emit(MessageReactedState(
          messageId: messageId,
          reactsCount: reactsCount,
          chatId: chatId,
        ));
      }
    });
  }

  void sendMessage({
    required SendMessageDto dto,
    required int currentUserId,
  }) {
    final tempMessage = MessageEntity(
      id: -1,
      content: dto.content,
      senderId: currentUserId,
      receiverId: dto.receiverId,
      chatId: dto.chatId,
      parentId: dto.parentId,
      createdAt: DateTime.now(),
      type: dto.type,
      mediaUrl: dto.mediaUrl,
      isFromMe: true,
      reactsCount: 0,
    );

    emit(NewOutgoingMessageState(tempMessage));
    socketRepo.sendMessage(dto.toSocketPayload());
  }

  void markChatAsRead({required int chatId}) {
    socketRepo.emitMarkChatAsRead(chatId);
  }

  void markMessageAsRead({
    required int chatId,
    required int messageId,
    required int senderId,
  }) {
    socketRepo.emitMessageRead(messageId, chatId, senderId);
  }

  void emitTyping({required int chatId}) {
    debugPrint("emit typing");
    socketRepo.emitTyping({
      "chatId": chatId,
    });
  }

  void emitStopTyping({required int chatId}) {
    debugPrint("emit stop typing");
    socketRepo.emitStopTyping({
      "chatId": chatId,
    });
  }

  void emitDeleteMessage({required int messageId}) {
    socketRepo.emitDeleteMessage(messageId);
    emit(DeleteMessageState(messageId: messageId));
  }

  void emitEditMessage({
    required int messageId,
    required String newContent,
  }) {
    socketRepo.emitEditMessage({
      "messageId": messageId,
      "content": newContent,
    });

    emit(EditMessageState(
      messageId: messageId,
      newContent: newContent,
    ));
  }

  void emitMessageReaction({
    required int messageId,
    required MessageReact reactType,
  }) {
    socketRepo.emitReactMessage({
      "messageId": messageId,
      "react": reactType.value,
    });
  }
}
