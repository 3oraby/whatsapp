import 'package:flutter/widgets.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:whatsapp/core/constants/storage_keys.dart';
import 'package:whatsapp/core/storage/app_storage_helper.dart';

class WebSocketService {
  Socket? _socket;

  void connect() async {
    final accessToken = await AppStorageHelper.getSecureData(
        StorageKeys.accessToken.toString());

    if (accessToken == null) {
      debugPrint("No access token found, socket not connected.");
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

    _socket!.onReconnect((_) => debugPrint("Reconnected to socket server"));
    _socket!.onConnect((_) => debugPrint("Connected to socket server ✅"));
    _socket!
        .onDisconnect((_) => debugPrint("onDisconnect from socket server ❗"));
    _socket!.onConnectError(
        (data) => debugPrint("Socket connection error: $data ❌"));
    _socket!.onError((err) => debugPrint("General socket error: $err ❌"));
  }

  void disconnect() {
    if (_socket?.connected == true) {
      _socket!.disconnect();
      debugPrint("Disconnected from socket server 🔌");
    }
  }

  void on(String event, Function(dynamic) callback) {
    _socket?.on(event, callback);
  }

  void emit(String event, dynamic data) {
    if (_socket?.connected == true) {
      _socket!.emit(event, data);
    } else {
      debugPrint("Socket not connected, can't emit $event");
    }
  }

  void dispose() {
    _socket?.dispose();
    _socket = null;
    print("Socket disposed");
  }
}
