import 'package:socket_io_client/socket_io_client.dart';
import 'package:whatsapp/core/api/end_points.dart';

class WebSocketService {
  static final WebSocketService _instance = WebSocketService._internal();
  factory WebSocketService() => _instance;

  late Socket socket;

  WebSocketService._internal();

  void initSocketConnection() {
    socket = io(
      EndPoints.webSocketUrl,
      {
        'transports': ['websocket'],
        'autoConnect': false,
      },
    );

    socket.connect();
  }

  void sendMessage(Map<String, dynamic> messageData) {
    socket.emit(
      'send_message',
      messageData,
    );
  }

  void listenToMessages(Function(Map<String, dynamic>) onMessage) {
    socket.on(
      'new_message',
      (data) => onMessage(data),
    );
  }

  void updateStatus(
    String userId,
    String status,
  ) {
    socket.emit(
      'update_status',
      {
        'userId': userId,
        'status': status,
      },
    );
  }

  void onStatusUpdate(Function(Map<String, dynamic>) callback) {
    socket.on(
      'user_status',
      (data) => callback(data),
    );
  }

  void markMessageAsSeen(String messageId) {
    socket.emit(
      'message_seen',
      {
        'messageId': messageId,
      },
    );
  }
}
