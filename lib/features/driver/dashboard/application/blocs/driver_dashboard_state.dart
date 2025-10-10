part of 'driver_dashboard_bloc.dart';

abstract class DriverDashboardState extends Equatable {
  const DriverDashboardState();

  @override
  List<Object?> get props => [];
}

class DriverDashboardInitial extends DriverDashboardState {}

class DriverDashboardLoading extends DriverDashboardState {}

class DriverDashboardLoaded extends DriverDashboardState {
  final bool isOnline;
  final int totalDeliveries;
  final double todayEarnings;
  final double rating;
  final List<Map<String, dynamic>> availableDeliveries;
  final List<Map<String, dynamic>> activeDeliveries;
  final List<Map<String, dynamic>> completedDeliveries;

  const DriverDashboardLoaded({
    required this.isOnline,
    required this.totalDeliveries,
    required this.todayEarnings,
    required this.rating,
    required this.availableDeliveries,
    required this.activeDeliveries,
    required this.completedDeliveries,
  });

  DriverDashboardLoaded copyWith({
    bool? isOnline,
    int? totalDeliveries,
    double? todayEarnings,
    double? rating,
    List<Map<String, dynamic>>? availableDeliveries,
    List<Map<String, dynamic>>? activeDeliveries,
    List<Map<String, dynamic>>? completedDeliveries,
  }) {
    return DriverDashboardLoaded(
      isOnline: isOnline ?? this.isOnline,
      totalDeliveries: totalDeliveries ?? this.totalDeliveries,
      todayEarnings: todayEarnings ?? this.todayEarnings,
      rating: rating ?? this.rating,
      availableDeliveries: availableDeliveries ?? this.availableDeliveries,
      activeDeliveries: activeDeliveries ?? this.activeDeliveries,
      completedDeliveries: completedDeliveries ?? this.completedDeliveries,
    );
  }

  @override
  List<Object?> get props => [
        isOnline,
        totalDeliveries,
        todayEarnings,
        rating,
        availableDeliveries,
        activeDeliveries,
        completedDeliveries,
      ];
}

class DriverDashboardError extends DriverDashboardState {
  final String message;

  const DriverDashboardError(this.message);

  @override
  List<Object?> get props => [message];
}
