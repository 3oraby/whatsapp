import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

part 'internet_connection_state.dart';

class InternetConnectionCubit extends Cubit<InternetConnectionState> {
  final Connectivity _connectivity;
  late final StreamSubscription<List<ConnectivityResult>> _subscription;

  InternetConnectionCubit(this._connectivity)
      : super(InternetConnectionInitial()) {
    _subscription = _connectivity.onConnectivityChanged.listen(_onConnectivityChanged);
    _checkInitialConnection();
  }

  Future<void> _checkInitialConnection() async {
    final result = await _connectivity.checkConnectivity();
    _onConnectivityChanged(result);
  }

  void _onConnectivityChanged(List<ConnectivityResult> results) {
    final hasConnection = results.any((result) => result != ConnectivityResult.none);

    if (hasConnection) {
      emit(InternetConnectionConnected());
    } else {
      emit(InternetConnectionDisconnected());
    }
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
