abstract class SocketRepo {
  void connect();
  void disconnect();

  void sendMessage(Map<String, dynamic> payload);
  void onReceiveMessage(Function(dynamic data) callback);

  void onTyping(Function(dynamic data) callback);
  void emitTyping(Map<String, dynamic> payload);

  void onMessageStatusUpdate(Function(dynamic data) callback);

  void emitMarkChatAsRead(int chatId);
  void emitMessageRead(int messageId, int chatId, int senderId);

  void onAllMessagesRead(Function(dynamic data) callback);

  void onMessageRead(Function(dynamic data) callback); 
}
