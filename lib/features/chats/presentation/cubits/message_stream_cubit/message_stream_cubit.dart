import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/features/chats/data/models/message_model.dart';
import 'package:whatsapp/features/chats/data/models/send_message_dto.dart';
import 'package:whatsapp/features/chats/domain/entities/message_entity.dart';
import 'package:whatsapp/features/chats/domain/enums/message_status.dart';
import 'package:whatsapp/features/chats/domain/repos/socket_repo.dart';

part 'message_stream_state.dart';

class MessageStreamCubit extends Cubit<MessageStreamState> {
  final SocketRepo socketRepo;
  final int chatId;

  MessageStreamCubit({
    required this.socketRepo,
    required this.chatId,
  }) : super(MessageStreamInitial()) {
    _initSocketListeners();
  }

  void _initSocketListeners() {
    socketRepo.onReceiveMessage((data) {
      final message = MessageModel.fromJson(data).toEntity();

      if (!isClosed) {
        markMessageAsRead(
          messageId: message.id,
          senderId: message.senderId,
        );
        emit(NewIncomingMessageState(message));
      }
    });

    socketRepo.onMessageStatusUpdate((data) {
      print('new status data: $data');
      final messageId = data["messageId"];

      final newStatus = (data["status"] as String).toMessageStatus();

      if (!isClosed) {
        emit(UpdateMessageStatusState(
          newId: messageId,
          newStatus: newStatus,
        ));
      }
    });

    socketRepo.onAllMessagesRead((data) {
      final int chatId = data["chatId"];
      if (!isClosed) {
        emit(AllMessagesReadInChatState(chatId: chatId));
      }
    });

    socketRepo.onMessageRead((data) {
      print('data');
      final int messageId = data['messageId'];

      if (!isClosed) {
        emit(UpdateMessageStatusState(
          newId: messageId,
          newStatus: MessageStatus.read,
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

  void markChatAsRead() {
    socketRepo.emitMarkChatAsRead(chatId);
  }

  void markMessageAsRead({
    required int messageId,
    required int senderId,
  }) {
    socketRepo.emitMessageRead(
      messageId,
      chatId,
      senderId,
    );
  }
}
