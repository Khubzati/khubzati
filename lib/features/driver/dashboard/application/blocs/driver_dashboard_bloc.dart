import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:khubzati/features/driver/dashboard/data/services/driver_dashboard_service.dart';

part 'driver_dashboard_event.dart';
part 'driver_dashboard_state.dart';

@injectable
class DriverDashboardBloc
    extends Bloc<DriverDashboardEvent, DriverDashboardState> {
  final DriverDashboardService driverDashboardService;

  DriverDashboardBloc({required this.driverDashboardService})
      : super(DriverDashboardInitial()) {
    on<LoadDriverDashboard>(_onLoadDriverDashboard);
    on<UpdateDriverStatus>(_onUpdateDriverStatus);
    on<AcceptDelivery>(_onAcceptDelivery);
    on<UpdateDeliveryStatus>(_onUpdateDeliveryStatus);
    on<UpdateDriverLocation>(_onUpdateDriverLocation);
  }

  Future<void> _onLoadDriverDashboard(
      LoadDriverDashboard event, Emitter<DriverDashboardState> emit) async {
    emit(DriverDashboardLoading());
    try {
      final dashboardData = await driverDashboardService.getDriverDashboard();
      emit(DriverDashboardLoaded(
        isOnline: dashboardData['is_online'] ?? false,
        totalDeliveries: dashboardData['total_deliveries'] ?? 0,
        todayEarnings: dashboardData['today_earnings'] ?? 0.0,
        rating: dashboardData['rating'] ?? 0.0,
        availableDeliveries: List<Map<String, dynamic>>.from(
            dashboardData['available_deliveries'] ?? []),
        activeDeliveries: List<Map<String, dynamic>>.from(
            dashboardData['active_deliveries'] ?? []),
        completedDeliveries: List<Map<String, dynamic>>.from(
            dashboardData['completed_deliveries'] ?? []),
      ));
    } catch (e) {
      emit(DriverDashboardError(e.toString()));
    }
  }

  Future<void> _onUpdateDriverStatus(
      UpdateDriverStatus event, Emitter<DriverDashboardState> emit) async {
    if (state is DriverDashboardLoaded) {
      final currentState = state as DriverDashboardLoaded;
      emit(DriverDashboardLoading());
      try {
        await driverDashboardService.updateDriverStatus(event.isOnline);
        emit(currentState.copyWith(isOnline: event.isOnline));
      } catch (e) {
        emit(DriverDashboardError(e.toString()));
      }
    }
  }

  Future<void> _onAcceptDelivery(
      AcceptDelivery event, Emitter<DriverDashboardState> emit) async {
    if (state is DriverDashboardLoaded) {
      final currentState = state as DriverDashboardLoaded;
      emit(DriverDashboardLoading());
      try {
        await driverDashboardService.acceptDelivery(event.deliveryId);
        // Remove from available and add to active
        final updatedAvailable = currentState.availableDeliveries
            .where((delivery) => delivery['id'] != event.deliveryId)
            .toList();
        final acceptedDelivery = currentState.availableDeliveries
            .firstWhere((delivery) => delivery['id'] == event.deliveryId);
        final updatedActive = [
          ...currentState.activeDeliveries,
          acceptedDelivery
        ];

        emit(currentState.copyWith(
          availableDeliveries: updatedAvailable,
          activeDeliveries: updatedActive,
        ));
      } catch (e) {
        emit(DriverDashboardError(e.toString()));
      }
    }
  }

  Future<void> _onUpdateDeliveryStatus(
      UpdateDeliveryStatus event, Emitter<DriverDashboardState> emit) async {
    if (state is DriverDashboardLoaded) {
      final currentState = state as DriverDashboardLoaded;
      emit(DriverDashboardLoading());
      try {
        await driverDashboardService.updateDeliveryStatus(
            event.deliveryId, event.status);

        // Update the delivery in active deliveries
        final updatedActive = currentState.activeDeliveries.map((delivery) {
          if (delivery['id'] == event.deliveryId) {
            return {...delivery, 'status': event.status};
          }
          return delivery;
        }).toList();

        // If completed, move to completed list
        if (event.status == 'delivered') {
          final completedDelivery = updatedActive
              .firstWhere((delivery) => delivery['id'] == event.deliveryId);
          final finalActive = updatedActive
              .where((delivery) => delivery['id'] != event.deliveryId)
              .toList();
          final updatedCompleted = [
            ...currentState.completedDeliveries,
            completedDelivery
          ];

          emit(currentState.copyWith(
            activeDeliveries: finalActive,
            completedDeliveries: updatedCompleted,
          ));
        } else {
          emit(currentState.copyWith(activeDeliveries: updatedActive));
        }
      } catch (e) {
        emit(DriverDashboardError(e.toString()));
      }
    }
  }

  Future<void> _onUpdateDriverLocation(
      UpdateDriverLocation event, Emitter<DriverDashboardState> emit) async {
    try {
      await driverDashboardService.updateDriverLocation(
          event.latitude, event.longitude);
    } catch (e) {
      // Location update errors shouldn't affect the UI state
      print('Location update error: $e');
    }
  }
}
