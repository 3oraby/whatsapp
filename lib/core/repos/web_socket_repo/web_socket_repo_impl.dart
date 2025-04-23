import 'package:whatsapp/core/repos/web_socket_repo/web_socket_repo.dart';
import 'package:whatsapp/core/services/web_socket_service.dart';

class WebSocketRepoImpl implements WebSocketRepo {
  final WebSocketService webSocketService;

  WebSocketRepoImpl({
    required this.webSocketService,
  });

  @override
  void sendMessage(Map<String, dynamic> data) {
    webSocketService.sendMessage(data);
  }

  @override
  void listenToMessages(Function(Map<String, dynamic>) onMessage) {
    webSocketService.listenToMessages(onMessage);
  }

  @override
  void updateStatus(String userId, String status) {
    webSocketService.updateStatus(userId, status);
  }

  @override
  void listenToUserStatus(Function(Map<String, dynamic>) onStatus) {
    webSocketService.onStatusUpdate(onStatus);
  }

  @override
  void markMessageAsSeen(String messageId) {
    webSocketService.markMessageAsSeen(messageId);
  }
}
