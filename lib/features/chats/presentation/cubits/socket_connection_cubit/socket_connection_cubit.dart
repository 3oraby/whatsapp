import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/features/chats/domain/repos/socket_repo.dart';

part 'socket_connection_state.dart';

class SocketConnectionCubit extends Cubit<SocketConnectionState> {
  final SocketRepo socketRepo;

  SocketConnectionCubit({
    required this.socketRepo,
  }) : super(SocketConnectionInitial());

  void connect() {
    emit(SocketConnecting());
    try {
      socketRepo.connect();
      emit(SocketConnected());
    } catch (e) {
      emit(SocketConnectionError(e.toString()));
    }
  }

  void disconnect() {
    socketRepo.disconnect();
    emit(SocketDisconnected());
  }
}
