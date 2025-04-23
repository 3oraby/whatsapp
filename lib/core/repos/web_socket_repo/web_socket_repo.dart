
abstract class WebSocketRepo {
  void sendMessage(Map<String, dynamic> data);
  void listenToMessages(Function(Map<String, dynamic>) onMessage);
  void updateStatus(String userId, String status);
  void listenToUserStatus(Function(Map<String, dynamic>) onStatus);
  void markMessageAsSeen(String messageId);
}
