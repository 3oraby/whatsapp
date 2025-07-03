import 'package:flutter/widgets.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:whatsapp/core/constants/storage_keys.dart';
import 'package:whatsapp/core/storage/app_storage_helper.dart';

class WebSocketService {
  static final WebSocketService _instance = WebSocketService._internal();
  factory WebSocketService() => _instance;
  WebSocketService._internal();

  Socket? _socket;

  Function(dynamic)? _onReceiveMessage;
  Function(dynamic)? _onMessageStatusUpdate;
  Function(dynamic)? _onTyping;
  Function(dynamic)? _onMessageRead;
  Function(dynamic)? _onAllMessagesRead;
  Function(dynamic)? _onFriendStatusUpdate;

  Future<void> connect() async {
    final accessToken =
        await AppStorageHelper.getSecureData(StorageKeys.accessToken.toString());

    if (accessToken == null) {
      debugPrint("❌ No access token found, socket not connected.");
      return;
    }

    _socket = io(
      'http://10.0.2.2:3000',
      OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .setAuth({'token': accessToken})
          .build(),
    );

    _socket!.connect();

    _socket!.onConnect((_) {
      debugPrint("✅ Connected to socket server");
      _registerAllListeners();
    });

    _socket!.onReconnect((_) {
      debugPrint("🔁 Reconnected to socket server");
      _registerAllListeners();
    });

    _socket!.onDisconnect((_) => debugPrint("❗ Disconnected from socket"));
    _socket!.onConnectError((err) => debugPrint("❌ Connect error: $err"));
    _socket!.onError((err) => debugPrint("❌ Socket error: $err"));
  }

  void _registerAllListeners() {
    if (_onReceiveMessage != null) {
      _socket!.off('receive_message');
      _socket!.on('receive_message', _onReceiveMessage!);
    }

    if (_onMessageStatusUpdate != null) {
      _socket!.off('status_update');
      _socket!.on('status_update', _onMessageStatusUpdate!);
    }

    if (_onTyping != null) {
      _socket!.off('typing');
      _socket!.on('typing', _onTyping!);
    }

    if (_onMessageRead != null) {
      _socket!.off('message_read');
      _socket!.on('message_read', _onMessageRead!);
    }

    if (_onAllMessagesRead != null) {
      _socket!.off('all messages readed successfully');
      _socket!.on('all messages readed successfully', _onAllMessagesRead!);
    }

    if (_onFriendStatusUpdate != null) {
      _socket!.off('friend_status_update');
      _socket!.on('friend_status_update', _onFriendStatusUpdate!);
    }
  }

  void onReceiveMessage(Function(dynamic) callback) {
    _onReceiveMessage = callback;
    if (_socket?.connected == true) {
      _socket!.on('receive_message', callback);
    }
  }

  void onMessageStatusUpdate(Function(dynamic) callback) {
    _onMessageStatusUpdate = callback;
    if (_socket?.connected == true) {
      _socket!.on('status_update', callback);
    }
  }

  void onTyping(Function(dynamic) callback) {
    _onTyping = callback;
    if (_socket?.connected == true) {
      _socket!.on('typing', callback);
    }
  }

  void onMessageRead(Function(dynamic) callback) {
    _onMessageRead = callback;
    if (_socket?.connected == true) {
      _socket!.on('message_read', callback);
    }
  }

  void onAllMessagesRead(Function(dynamic) callback) {
    _onAllMessagesRead = callback;
    if (_socket?.connected == true) {
      _socket!.on('all messages readed successfully', callback);
    }
  }

  void onFriendStatusUpdate(Function(dynamic) callback) {
    _onFriendStatusUpdate = callback;
    if (_socket?.connected == true) {
      _socket!.on('friend_status_update', callback);
    }
  }

  void emit(String event, dynamic data) {
    if (_socket?.connected == true) {
      _socket!.emit(event, data);
    } else {
      debugPrint("Socket not connected, can't emit $event");
    }
  }

  void disconnect() {
    if (_socket?.connected == true) {
      _socket!.disconnect();
      debugPrint("🔌 Socket disconnected");
    }
  }

  void dispose() {
    _socket?.dispose();
    _socket = null;
    debugPrint("🧹 Socket disposed");
  }
}
