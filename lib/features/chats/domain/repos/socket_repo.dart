abstract class SocketRepo {
  void connect({
    required String accessToken,
  });
  void disconnect();
  void dispose();

  void sendMessage(Map<String, dynamic> payload);
  void onReceiveMessage(Function(dynamic data) callback);

  void onTyping(Function(dynamic data) callback);
  void emitTyping(Map<String, dynamic> payload);

  void onStopTyping(Function(dynamic data) callback);
  void emitStopTyping(Map<String, dynamic> payload);

  void onMessageStatusUpdate(Function(dynamic data) callback);

  void emitMarkChatAsRead(int chatId);
  void emitMessageRead(int messageId, int chatId, int senderId);

  void onAllMessagesRead(Function(dynamic data) callback);

  void onMessageRead(Function(dynamic data) callback);

  void onFriendStatusUpdate(Function(dynamic data) callback);

  void emitDeleteMessage(int messageId);

  void onMessageDeletedSuccessfully(Function(dynamic data) callback);
  void emitEditMessage(Map<String, dynamic> payload);

  void onMessageEditedSuccessfully(Function(dynamic data) callback);
  void onEditMessage(Function(dynamic data) callback);
  void onDeleteMessage(Function(dynamic data) callback);
  void onReactMessage(Function(dynamic data) callback);

  void emitReactMessage(Map<String, dynamic> payload);

  void onMessageReactedSuccessfully(Function(dynamic data) callback);
}
