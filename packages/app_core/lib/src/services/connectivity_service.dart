// ignore_for_file: lines_longer_than_80_chars

import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

enum NetworkConnectionStatus { unknown, connected, disconnected }

abstract class NetworkConnectionEvent extends Equatable {
  const NetworkConnectionEvent();
  @override
  List<Object> get props => [];
}

class CheckingConnection extends NetworkConnectionEvent {}

class ConnectionStatusChanged extends NetworkConnectionEvent {
  const ConnectionStatusChanged(this.connectivityResult);
  final ConnectivityResult connectivityResult;
  @override
  List<Object> get props => [connectivityResult];
}

class NetworkConnectionState extends Equatable {
  const NetworkConnectionState._({
    this.networkConnectionStatus = NetworkConnectionStatus.unknown,
  });

  const NetworkConnectionState.unknown() : this._();
  const NetworkConnectionState.connected()
      : this._(
          networkConnectionStatus: NetworkConnectionStatus.connected,
        );
  const NetworkConnectionState.disconnected()
      : this._(
          networkConnectionStatus: NetworkConnectionStatus.disconnected,
        );

  final NetworkConnectionStatus networkConnectionStatus;

  @override
  List<Object> get props => [networkConnectionStatus];
}

@singleton
class NetworkConnectionBloc extends Bloc<NetworkConnectionEvent, NetworkConnectionState> {
  NetworkConnectionBloc() : super(const NetworkConnectionState.unknown()) {
    //listen for network connection changes
    connectivitySubscription = Connectivity().onConnectivityChanged.listen((connectivityResult) => add(ConnectionStatusChanged(connectivityResult)));

    on<ConnectionStatusChanged>((event, emit) async => emit(await _mapConnectionStatusChangedToState(event)));
  }

  late StreamSubscription<ConnectivityResult> connectivitySubscription;

  Future<NetworkConnectionState> _mapConnectionStatusChangedToState(
    ConnectionStatusChanged event,
  ) async {
    if (event.connectivityResult != ConnectivityResult.none) {
      final isDeviceConnected = await InternetConnectionChecker().hasConnection;
      return isDeviceConnected ? const NetworkConnectionState.connected() : const NetworkConnectionState.disconnected();
    }
    return const NetworkConnectionState.unknown();
  }

  @override
  Future<void> close() {
    connectivitySubscription.cancel();
    return super.close();
  }
}
