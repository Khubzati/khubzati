import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:khubzati/features/network/application/blocs/network_event.dart';
import 'package:khubzati/features/network/application/blocs/network_state.dart'
    as states;

class NetworkBloc extends Bloc<NetworkEvent, states.NetworkState> {
  final Connectivity _connectivity = Connectivity();

  NetworkBloc() : super(const states.NetworkInitial()) {
    on<NetworkCheckRequested>(_onNetworkCheckRequested);
    on<NetworkRetryRequested>(_onNetworkRetryRequested);

    // Listen to connectivity changes
    _connectivity.onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      if (results.contains(ConnectivityResult.none)) {
        add(const NetworkDisconnected());
      } else {
        add(const NetworkConnected());
      }
    });
  }

  Future<void> _onNetworkCheckRequested(
    NetworkCheckRequested event,
    Emitter<states.NetworkState> emit,
  ) async {
    emit(const states.NetworkChecking());

    final connectivityResult = await _connectivity.checkConnectivity();

    if (connectivityResult.contains(ConnectivityResult.none)) {
      emit(const states.NetworkDisconnected());
    } else {
      emit(const states.NetworkConnected());
    }
  }

  Future<void> _onNetworkRetryRequested(
    NetworkRetryRequested event,
    Emitter<states.NetworkState> emit,
  ) async {
    emit(const states.NetworkChecking());

    final connectivityResult = await _connectivity.checkConnectivity();

    if (connectivityResult.contains(ConnectivityResult.none)) {
      emit(const states.NetworkDisconnected());
    } else {
      emit(const states.NetworkConnected());
    }
  }
}
