import 'dart:async';
import 'dart:developer';

import 'package:socket_io_client/socket_io_client.dart';
import 'package:whatsapp/core/constants/storage_keys.dart';
import 'package:whatsapp/core/storage/app_storage_helper.dart';

class WebSocketService {
  Socket? _socket;
  Timer? _socketIdTimer;

  void connect() async {
    final accessToken = await AppStorageHelper.getSecureData(
        StorageKeys.accessToken.toString());

    if (accessToken == null) {
      print("No access token found, socket not connected.");
      return;
    }
    print("tokeen found: $accessToken");
    _socket = io(
      'http://10.0.2.2:3000',
      OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setAuth({'token': accessToken})
          .build(),
    );

    _socket!.connect();

    _socket!.onReconnect((_) => log("Reconnected to socket server"));
    _socket!.onConnect((_) {
      log("Connected to socket server ✅");

      _socketIdTimer = Timer.periodic(const Duration(seconds: 1), (_) {
        print("⏱ Socket ID (every 1s): ${_socket?.id}");
      });
    });

    _socket!.onDisconnect((_) => log("onDisconnect from socket server ❗"));
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
