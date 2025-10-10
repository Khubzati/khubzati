part of 'driver_dashboard_bloc.dart';

abstract class DriverDashboardEvent extends Equatable {
  const DriverDashboardEvent();

  @override
  List<Object?> get props => [];
}

class LoadDriverDashboard extends DriverDashboardEvent {
  const LoadDriverDashboard();
}

class UpdateDriverStatus extends DriverDashboardEvent {
  final bool isOnline;

  const UpdateDriverStatus({required this.isOnline});

  @override
  List<Object?> get props => [isOnline];
}

class AcceptDelivery extends DriverDashboardEvent {
  final String deliveryId;

  const AcceptDelivery({required this.deliveryId});

  @override
  List<Object?> get props => [deliveryId];
}

class UpdateDeliveryStatus extends DriverDashboardEvent {
  final String deliveryId;
  final String status;

  const UpdateDeliveryStatus({
    required this.deliveryId,
    required this.status,
  });

  @override
  List<Object?> get props => [deliveryId, status];
}

class UpdateDriverLocation extends DriverDashboardEvent {
  final double latitude;
  final double longitude;

  const UpdateDriverLocation({
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object?> get props => [latitude, longitude];
}
