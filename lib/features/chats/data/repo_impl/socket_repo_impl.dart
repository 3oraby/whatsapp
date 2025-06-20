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
}
