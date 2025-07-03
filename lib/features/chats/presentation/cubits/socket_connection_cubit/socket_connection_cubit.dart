import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/features/chats/domain/repos/socket_repo.dart';

part 'socket_connection_state.dart';

class SocketConnectionCubit extends Cubit<SocketConnectionState> {
  final SocketRepo socketRepo;

  SocketConnectionCubit({
    required this.socketRepo,
  }) : super(SocketConnectionInitial());

  void connect() {
    debugPrint("call connect on socket from the cubit");
    if (state is SocketConnected || state is SocketConnecting) {
      debugPrint("SocketConnectionCubit: Already connected or connecting");
      return;
    }

    emit(SocketConnecting());

    try {
      socketRepo.connect();
      emit(SocketConnected());
    } catch (e) {
      emit(SocketConnectionError(e.toString()));
    }
  }

  void disconnect() {
    debugPrint("call disConnect from socket from the cubit");
    if (state is SocketDisconnected || state is SocketConnectionInitial) {
      debugPrint(
          "SocketConnectionCubit: Already disconnected or not connected");
      return;
    }

    socketRepo.disconnect();
    emit(SocketDisconnected());
  }

  void dispose() {
    debugPrint("call dispose socket from the cubit");
    socketRepo.dispose();
    emit(SocketConnectionInitial());
  }
}
