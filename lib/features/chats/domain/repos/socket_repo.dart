abstract class SocketRepo {
  void connect();
  void disconnect();
  
  void sendMessage(Map<String, dynamic> payload);
  void onReceiveMessage(Function(dynamic data) callback);
  
  void onTyping(Function(dynamic data) callback);
  void emitTyping(Map<String, dynamic> payload);

}
