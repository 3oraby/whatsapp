import 'dart:async';
import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:whatsapp/features/chats/presentation/cubits/socket_connection_cubit/socket_connection_cubit.dart';

part 'internet_connection_state.dart';

class InternetConnectionCubit extends Cubit<InternetConnectionState> {
  final Connectivity connectivity;
  late final StreamSubscription<List<ConnectivityResult>> _subscription;
  final SocketConnectionCubit socketConnectionCubit;

  InternetConnectionCubit({
    required this.connectivity,
    required this.socketConnectionCubit,
  }) : super(InternetConnectionInitial()) {
    _subscription =
        connectivity.onConnectivityChanged.listen(_onConnectivityChanged);
    _checkInitialConnection();
  }

  Future<void> _checkInitialConnection() async {
    final result = await connectivity.checkConnectivity();
    _onConnectivityChanged(result);
  }

  void _onConnectivityChanged(List<ConnectivityResult> results) {
    final hasConnection = !results.contains(ConnectivityResult.none);
    log("listen on internet");
    if (hasConnection) {
      socketConnectionCubit.connect();
      emit(InternetConnectionConnected());
    } else {
      socketConnectionCubit.dispose();
      emit(InternetConnectionDisconnected());
    }
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
