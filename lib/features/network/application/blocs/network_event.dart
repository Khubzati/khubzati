import 'package:equatable/equatable.dart';

abstract class NetworkEvent extends Equatable {
  const NetworkEvent();

  @override
  List<Object?> get props => [];
}

class NetworkCheckRequested extends NetworkEvent {
  const NetworkCheckRequested();
}

class NetworkRetryRequested extends NetworkEvent {
  const NetworkRetryRequested();
}

class NetworkConnected extends NetworkEvent {
  const NetworkConnected();
}

class NetworkDisconnected extends NetworkEvent {
  const NetworkDisconnected();
}
