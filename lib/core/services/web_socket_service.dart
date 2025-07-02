import 'dart:async';
import 'dart:developer';

import 'package:socket_io_client/socket_io_client.dart';
import 'package:whatsapp/core/constants/storage_keys.dart';
import 'package:whatsapp/core/storage/app_storage_helper.dart';

class WebSocketService {
  Socket? _socket;
  Timer? _socketIdTimer;

  bool get isConnected => _socket?.connected ?? false;

  Future<void> connect() async {
    if (isConnected) {
      print("⚠️ Socket is already connected, skipping connect()");
      return;
    }

    if (_socket != null) {
      print("🧹 Cleaning up old socket connection...");
      _socket!.dispose();
      _socket = null;
      _socketIdTimer?.cancel();
      _socketIdTimer = null;
    }

    final accessToken = await AppStorageHelper.getSecureData(
      StorageKeys.accessToken.toString(),
    );

    if (accessToken == null) {
      print("No access token found, socket not connected.");
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
    _socket!.onConnect((_) async {
      print("Connected to socket server ✅");
      print("1");
      await Future.delayed(Duration(seconds: 5));
      print("2");
      Future.delayed(Duration(seconds: 2), () {
        print("After 2 seconds");
      });

      print("Continuing execution...");
    });

    // _socketIdTimer = Timer.periodic(const Duration(seconds: 10), (_) {
    //   print("⏱ Socket ID: ${_socket?.id}");
    // });
    _socket!.onDisconnect((_) {
      print("Disconnected from socket server ❗");
      _socketIdTimer?.cancel();
      _socketIdTimer = null;
    });

    _socket!.onConnectError((data) => print("Connect error: $data"));
    _socket!.onError((err) => print("Socket error: $err"));
  }

  void disconnect() {
    if (!isConnected) {
      print("⚠️ Socket already disconnected, skipping disconnect()");
      return;
    }
    _socket!.disconnect();
    _socketIdTimer?.cancel();
    _socketIdTimer = null;
    print("Disconnected from socket server 🔌");
  }

  void dispose() {
    _socket?.dispose();
    _socket = null;
    _socketIdTimer?.cancel();
    _socketIdTimer = null;
    print("Socket disposed");
  }

  void on(String event, Function(dynamic) callback) {
    _socket?.on(event, callback);
  }

  void emit(String event, dynamic data) {
    _socket?.emit(event, data);
  }
}
