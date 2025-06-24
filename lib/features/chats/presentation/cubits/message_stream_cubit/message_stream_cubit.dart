import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/features/chats/data/models/message_model.dart';
import 'package:whatsapp/features/chats/data/models/send_message_dto.dart';
import 'package:whatsapp/features/chats/domain/entities/message_entity.dart';
import 'package:whatsapp/features/chats/domain/enums/message_status.dart';
import 'package:whatsapp/features/chats/domain/repos/socket_repo.dart';

part 'message_stream_state.dart';

class MessageStreamCubit extends Cubit<MessageStreamState> {
  final SocketRepo socketRepo;

  MessageStreamCubit({
    required this.socketRepo,
  }) : super(MessageStreamInitial()) {
    _initSocketListeners();
  }

  void _initSocketListeners() {
    socketRepo.onReceiveMessage((data) {
      final message = MessageModel.fromJson(data).toEntity();
      if (!isClosed) {
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
      createdAt: DateTime.now(),
      type: dto.type,
      mediaUrl: dto.mediaUrl,
      isFromMe: true,
      reactsCount: 0,
    );

    emit(NewOutgoingMessageState(tempMessage));
    socketRepo.sendMessage(dto.toSocketPayload());
  }
}
