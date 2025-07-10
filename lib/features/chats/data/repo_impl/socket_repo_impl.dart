import 'package:whatsapp/core/services/web_socket_service.dart';
import 'package:whatsapp/core/socket/socket_events.dart';
import 'package:whatsapp/features/chats/domain/repos/socket_repo.dart';

class SocketRepoImpl implements SocketRepo {
  final WebSocketService webSocketService;

  SocketRepoImpl({required this.webSocketService});

  @override
  void connect({required String accessToken}) =>
      webSocketService.connect(accessToken: accessToken);

  @override
  void disconnect() => webSocketService.disconnect();

  @override
  void dispose() => webSocketService.dispose();

  @override
  void sendMessage(Map<String, dynamic> payload) {
    webSocketService.emit(SocketEvents.sendMessage, payload);
  }

  @override
  void onReceiveMessage(Function(dynamic data) callback) {
    webSocketService.addListener(SocketEvents.receiveMessage, callback);
  }

  @override
  void onTyping(Function(dynamic data) callback) {
    webSocketService.addListener(SocketEvents.typing, callback);
  }

  @override
  void emitTyping(Map<String, dynamic> payload) {
    webSocketService.emit(SocketEvents.typing, payload);
  }

  @override
  void onStopTyping(Function(dynamic data) callback) {
    webSocketService.addListener(SocketEvents.stopTyping, callback);
  }

  @override
  void emitStopTyping(Map<String, dynamic> payload) {
    webSocketService.emit(SocketEvents.stopTyping, payload);
  }

  @override
  void onMessageStatusUpdate(Function(dynamic data) callback) {
    webSocketService.addListener(SocketEvents.statusUpdate, callback);
  }

  @override
  void emitMarkChatAsRead(int chatId) {
    webSocketService.emit(SocketEvents.markChatAsRead, {
      'chatId': chatId,
    });
  }

  @override
  void emitMessageRead(int messageId, int chatId, int senderId) {
    webSocketService.emit(SocketEvents.messageRead, {
      'messageId': messageId,
      'chatId': chatId,
      'senderId': senderId,
    });
  }

  @override
  void onAllMessagesRead(Function(dynamic data) callback) {
    webSocketService.addListener(SocketEvents.allMessagesRead, callback);
  }

  @override
  void onMessageRead(Function(dynamic data) callback) {
    webSocketService.addListener(SocketEvents.messageRead, callback);
  }

  @override
  void onFriendStatusUpdate(Function(dynamic data) callback) {
    webSocketService.addListener(SocketEvents.friendStatusUpdate, callback);
  }

  @override
  void emitDeleteMessage(int messageId) {
    webSocketService.emit(
      SocketEvents.deleteMessage,
      {
        'messageId': messageId,
      },
    );
  }

  @override
  void emitEditMessage(Map<String, dynamic> payload) {
    webSocketService.emit(
      SocketEvents.emitEditMessage,
      payload,
    );
  }

  @override
  void onMessageDeletedSuccessfully(Function(dynamic data) callback) {
    webSocketService.addListener(
        SocketEvents.messageDeletedSuccessfully, callback);
  }

  @override
  void onMessageEditedSuccessfully(Function(dynamic data) callback) {
    webSocketService.addListener(
        SocketEvents.messageEditedSuccessfully, callback);
  }

  @override
  void emitReactMessage(Map<String, dynamic> payload) {
    webSocketService.emit(
      SocketEvents.messageReact,
      payload,
    );
  }

  @override
  void onMessageReactedSuccessfully(Function(dynamic data) callback) {
    webSocketService.addListener(
        SocketEvents.messageReactedSuccessfully, callback);
  }

  @override
  void onEditMessage(Function(dynamic data) callback) {
    webSocketService.addListener(SocketEvents.onEditMessage, callback);
  }


  @override
  void onDeleteMessage (Function(dynamic data) callback) {
    webSocketService.addListener(SocketEvents.onDeleteMessage, callback);
  }
}
