import 'package:whatsapp/core/services/web_socket_service.dart';
import '../../domain/repos/socket_repo.dart';

class SocketRepoImpl implements SocketRepo {
  final WebSocketService webSocketService;

  SocketRepoImpl({required this.webSocketService});

  @override
  void connect() {
    webSocketService.connect();
  }

  @override
  void disconnect() {
    webSocketService.disconnect();
  }

  @override
  void onFriendStatusUpdate(Function(dynamic data) callback) {
    webSocketService.on('friend_status_update', callback);
  }

  @override
  void sendMessage(Map<String, dynamic> payload) {
    webSocketService.emit('send_message', payload);
  }

  @override
  void onReceiveMessage(Function(dynamic data) callback) {
    webSocketService.on('receive_message', callback);
  }

  @override
  void onTyping(Function(dynamic data) callback) {
    webSocketService.on('typing', callback);
  }

  @override
  void emitTyping(Map<String, dynamic> payload) {
    webSocketService.emit('typing', payload);
  }

  @override
  void onMessageStatusUpdate(Function(dynamic data) callback) {
    webSocketService.on('status_update', callback);
  }

  @override
  void emitMarkChatAsRead(int chatId) {
    webSocketService.emit('mark_chat_as_read', {
      'chatId': chatId,
    });
  }

  @override
  void emitMessageRead(int messageId, int chatId, int senderId) {
    webSocketService.emit('message_read', {
      'messageId': messageId,
      'chatId': chatId,
      'senderId': senderId,
    });
  }

  @override
  void onAllMessagesRead(Function(dynamic data) callback) {
    webSocketService.on('all messages readed successfully', callback);
  }

  @override
  void onMessageRead(Function(dynamic data) callback) {
    webSocketService.on('message_read', callback);
  }
}
