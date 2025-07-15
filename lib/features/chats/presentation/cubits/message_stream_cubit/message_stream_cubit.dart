import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/core/helpers/pending_messages/pending_message_helper.dart';
import 'package:whatsapp/features/chats/data/models/message_model.dart';
import 'package:whatsapp/features/chats/data/models/message_reaction_event_model.dart';
import 'package:whatsapp/features/chats/data/models/send_message_dto.dart';
import 'package:whatsapp/features/chats/domain/entities/message_entity.dart';
import 'package:whatsapp/features/chats/domain/entities/message_reaction_event.dart';
import 'package:whatsapp/features/chats/domain/enums/message_react.dart';
import 'package:whatsapp/features/chats/domain/enums/message_status.dart';
import 'package:whatsapp/features/chats/domain/repos/socket_repo.dart';

part 'message_stream_state.dart';

class MessageStreamCubit extends Cubit<MessageStreamState> {
  final SocketRepo socketRepo;
  final PendingMessagesHelper pendingMessagesHelper;

  MessageStreamCubit({
    required this.socketRepo,
    required this.pendingMessagesHelper,
  }) : super(MessageStreamInitial()) {
    _initSocketListeners();
  }

  void _initSocketListeners() {
    socketRepo.onReceiveMessage((data) {
      debugPrint("✅ New message: $data");
      final message = MessageModel.fromJson(data).toEntity();

      final receivedMessage = message.copyWith(status: MessageStatus.read);
      if (!isClosed) {
        emit(NewIncomingMessageState(receivedMessage));
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

    socketRepo.onDeleteMessage((data) {
      debugPrint("🗑 Deleted: $data");
      final int messageId = data["messageId"];

      if (!isClosed) {
        emit(MessageDeletedSuccessfullyState(
          messageId: messageId,
        ));
      }
    });

    socketRepo.onReactMessage((data) {
      debugPrint("❤️ Reacted: $data");
      final reaction = MessageReactionEventModel.fromJson(data);

      if (!isClosed) {
        if (reaction.action == "created_or_updated") {
          emit(CreateMessageReactSuccessfullyState(
              messageReaction: reaction.toEntity()));
        } else {
          emit(DeleteMessageReactSuccessfullyState(
            messageReaction: reaction.toEntity(),
          ));
        }
      }
    });
  }

  void sendMessage({
    required SendMessageDto dto,
    required int currentUserId,
  }) async {
    final tempMessage = MessageEntity.fromDto(dto, currentUserId);

    emit(NewOutgoingMessageState(tempMessage));
    if (!socketRepo.isConnected) {
      await pendingMessagesHelper.addPendingMessage(dto.toSocketPayload());
      return;
    }

    socketRepo.sendMessage(dto.toSocketPayload());
  }

  Future<void> resendPendingMessagesForChat(int chatId) async {
    try {
      debugPrint("resendPendingMessagesForChat");
      if (!socketRepo.isConnected) {
        debugPrint("❌ Socket not connected. Waiting for connection...");
        await _waitForSocketConnectionWithTimeout();
      }
      final pending = await pendingMessagesHelper.getPendingMessages();

      for (final json in pending) {
        final messageDto = SendMessageDto.fromJson(json);
        if (messageDto.chatId == chatId) {
          debugPrint("Send pending message: $json");

          socketRepo.sendMessage(json);
          await Future.delayed(Duration(milliseconds: 1000));
          await pendingMessagesHelper.removePendingMessage(json);
        }
      }
    } catch (e) {
      debugPrint("Error while resending messages: $e");
    }
  }

  Future<void> _waitForSocketConnectionWithTimeout() async {
    final completer = Completer<void>();

    if (socketRepo.isConnected) {
      debugPrint("✅ Socket already connected.");
      return;
    }

    late void Function(dynamic) onConnect;
    onConnect = (_) {
      debugPrint("✅ Socket connected during wait.");
      if (!completer.isCompleted) {
        completer.complete();
      }
    };

    socketRepo.onConnect(onConnect);

    try {
      await completer.future.timeout(const Duration(seconds: 10));
    } catch (_) {
      debugPrint("⏰ Timeout while waiting for socket to connect.");
    } finally {
      socketRepo.offConnect(onConnect);
    }
  }

  void markChatAsRead({required int chatId}) {
    socketRepo.emitMarkChatAsRead(chatId);
  }

  void markMessageAsRead({
    required int chatId,
    required int messageId,
    required int senderId,
  }) {
    socketRepo.emitMessageRead(
      messageId,
      chatId,
      senderId,
    );
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
    required bool isCreate,
  }) {
    debugPrint("toggle message react");
    socketRepo.emitReactMessage({
      "messageId": messageId,
      "react": reactType.value,
    });
    if (isCreate) {
      emit(CreateNewReactMessageState(
        messageId: messageId,
        reactType: reactType,
      ));
    } else {
      emit(DeleteReactMessageState(
        messageId: messageId,
        reactType: reactType,
      ));
    }
  }
}
