import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:whatsapp/core/api/api_urls.dart';

class WebSocketService {
  Socket? socket;

  final List<MapEntry<String, Function(dynamic)>> _queuedListeners = [];
  bool get isConnected => socket?.connected == true;

  void connect({
    required String accessToken,
  }) {
    if (socket != null && socket!.connected) {
      debugPrint("⚠️ Socket already connected. Skipping re-connection.");
      return;
    }

    debugPrint("🚀 Creating new socket instance...");
    log("token before socket connection : $accessToken");
    log("xxxxxxxxxx");
    socket = io(
      ApiUrls.webSocketUrl,
      OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setPath('/chat/socket.io')
          .setQuery({
            'token': accessToken,
          })
          .build(),
    );

    socket!.connect();

    socket!.onConnect((_) {
      debugPrint("✅ Socket connected");
      for (var listener in _queuedListeners) {
        socket!.on(
          listener.key,
          listener.value,
        );
      }
    });

    socket!.onDisconnect((_) => debugPrint("❌ Disconnected from socket"));
    socket!.onConnectError((err) => debugPrint("⛔ Connect error: $err"));
    socket!.onError((err) => debugPrint("❗ Socket error: $err"));
  }

  void addListener(String event, Function(dynamic) callback) {
    if (socket?.connected == true) {
      socket!.on(event, callback);
    } else {
      _queuedListeners.add(MapEntry(event, callback));
    }
  }

  void emit(String event, dynamic data) {
    if (socket?.connected == true) {
      socket!.emit(event, data);
    } else {
      debugPrint("⚠️ Cannot emit, socket not connected");
    }
  }

  void disconnect() {
    if (socket != null) {
      socket!.offAny();
      socket!.disconnect();
      debugPrint("🔌 Socket disconnected");
    }
  }

  void dispose() {
    if (socket != null) {
      socket!.offAny();
      socket!.dispose();
      socket!.destroy();
      socket = null;
      debugPrint("🗑️ Socket disposed");
    }
  }
}
