import 'dart:developer';

import 'package:socket_io_client/socket_io_client.dart';
import 'package:whatsapp/core/constants/storage_keys.dart';
import 'package:whatsapp/core/storage/app_storage_helper.dart';

class WebSocketService {
  Socket? _socket;

  void connect() async {
    final accessToken = await AppStorageHelper.getSecureData(
        StorageKeys.accessToken.toString());

    if (accessToken == null) {
      log("❌ No access token found, socket not connected.");
      return;
    }

    _socket = io(
      'http://10.0.2.2:3000',
      OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setAuth({'token': accessToken})
          .build(),
    );

    _socket!.connect();

    _socket!.onConnect((_) => log("Connected to socket server ✅"));
    _socket!.onDisconnect((_) => log("Disconnected from socket server ❗"));
    _socket!.onConnectError((data) => log("Socket connection error: $data ❌"));
    _socket!.onError((err) => log("General socket error: $err ❌"));
  }

  void disconnect() {
    if (_socket?.connected == true) {
      _socket!.disconnect();
      log("Disconnected from socket server 🔌");
    }
  }

  void on(String event, Function(dynamic) callback) {
    _socket?.on(event, callback);
  }

  void emit(String event, dynamic data) {
    _socket?.emit(event, data);
  }
}
