part of 'socket_connection_cubit.dart';

abstract class SocketConnectionState {}

class SocketConnectionInitial extends SocketConnectionState {}

class SocketConnecting extends SocketConnectionState {}

class SocketConnected extends SocketConnectionState {}

class SocketDisconnected extends SocketConnectionState {}

class SocketConnectionError extends SocketConnectionState {
  final String message;

  SocketConnectionError(this.message);
}
