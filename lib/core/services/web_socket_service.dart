import 'dart:developer';

import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:whatsapp/core/api/end_points.dart';

class WebSocketService {
  static final WebSocketService _instance = WebSocketService._internal();
  factory WebSocketService() => _instance;

  late IO.Socket socket;

  WebSocketService._internal();

  void initSocketConnection() {
    socket = IO.io(
      EndPoints.webSocketUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );

    socket.connect();

    socket.onConnect((_) => log('✅ Connected to socket'));
    socket.onDisconnect((_) => log('❌ Disconnected from socket'));
    socket.onConnectError((err) => log('⚠️ Connect error: $err'));
  }

  void sendMessage(Map<String, dynamic> messageData) {
    if (socket.connected) {
      socket.emit('send_message', messageData);
    } else {
      log("❌ Can't send message: Socket not connected");
    }
  }

  void listenToMessages(Function(Map<String, dynamic>) onMessage) {
    socket.on('new_message', (data) {
      if (data is Map<String, dynamic>) {
        onMessage(data);
      } else {
        log("⚠️ Unexpected message data: $data");
      }
    });
  }

  void updateStatus(String userId, String status) {
    socket.emit('update_status', {'userId': userId, 'status': status});
  }

  void onStatusUpdate(Function(Map<String, dynamic>) callback) {
    socket.on('user_status', (data) => callback(data));
  }

  void markMessageAsSeen(String messageId) {
    socket.emit('message_seen', {'messageId': messageId});
  }

  void dispose() {
    socket.dispose();
  }
}
