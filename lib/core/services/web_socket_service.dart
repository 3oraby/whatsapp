import 'package:flutter/widgets.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:whatsapp/core/constants/storage_keys.dart';
import 'package:whatsapp/core/storage/app_storage_helper.dart';

class WebSocketService {
  Socket? _socket;

  final List<MapEntry<String, Function(dynamic)>> _queuedListeners = [];

  void connect() async {
    if (_socket != null && _socket!.connected) {
      debugPrint("⚠️ Socket already connected. Skipping re-connection.");
      return;
    }

    final accessToken = await AppStorageHelper.getSecureData(
        StorageKeys.accessToken.toString());

    if (accessToken == null) {
      debugPrint("⛔ No access token found, socket not connected.");
      return;
    }

    debugPrint("🚀 Creating new socket instance...");

    _socket = io(
      'http://10.0.2.2:3000',
      OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .setAuth({'token': accessToken})
          .build(),
    );

    _socket!.onConnect((_) {
      debugPrint("✅ Socket connected");
      for (var listener in _queuedListeners) {
        _socket!.on(
          listener.key,
          listener.value,
        );
      }
    });

    _socket!.onDisconnect((_) => debugPrint("❌ Disconnected from socket"));
    _socket!.onConnectError((err) => debugPrint("⛔ Connect error: $err"));
    _socket!.onError((err) => debugPrint("❗ Socket error: $err"));
  }

  void addListener(String event, Function(dynamic) callback) {
    if (_socket?.connected == true) {
      _socket!.on(event, callback);
    } else {
      _queuedListeners.add(MapEntry(event, callback));
    }
  }

  void emit(String event, dynamic data) {
    if (_socket?.connected == true) {
      _socket!.emit(event, data);
    } else {
      debugPrint("⚠️ Cannot emit, socket not connected");
    }
  }

  void disconnect() {
    if (_socket != null) {
      _socket!.offAny();
      _socket!.disconnect();
      debugPrint("🔌 Socket disconnected");
    }
  }

  void dispose() {
    if (_socket != null) {
      _socket!.offAny();
      _socket!.dispose();
      _socket = null;
      debugPrint("🗑️ Socket disposed");
    }
  }
}
