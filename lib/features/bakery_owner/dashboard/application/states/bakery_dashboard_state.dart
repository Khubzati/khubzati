part of 'bakery_dashboard_bloc.dart';

abstract class BakeryDashboardState extends Equatable {
  const BakeryDashboardState();

  @override
  List<Object?> get props => [];
}

class BakeryDashboardInitial extends BakeryDashboardState {}

class BakeryDashboardLoading extends BakeryDashboardState {}

class BakeryDashboardLoaded extends BakeryDashboardState {
  final Map<String, dynamic> bakeryInfo;
  final Map<String, dynamic> stats;
  final List<Map<String, dynamic>> recentOrders;
  final List<Map<String, dynamic>> popularProducts;
  final bool isOpen;
  final String timeRange; // 'today', 'week', 'month', 'year'

  const BakeryDashboardLoaded({
    required this.bakeryInfo,
    required this.stats,
    required this.recentOrders,
    required this.popularProducts,
    required this.isOpen,
    this.timeRange = 'today',
  });

  BakeryDashboardLoaded copyWith({
    Map<String, dynamic>? bakeryInfo,
    Map<String, dynamic>? stats,
    List<Map<String, dynamic>>? recentOrders,
    List<Map<String, dynamic>>? popularProducts,
    bool? isOpen,
    String? timeRange,
  }) {
    return BakeryDashboardLoaded(
      bakeryInfo: bakeryInfo ?? this.bakeryInfo,
      stats: stats ?? this.stats,
      recentOrders: recentOrders ?? this.recentOrders,
      popularProducts: popularProducts ?? this.popularProducts,
      isOpen: isOpen ?? this.isOpen,
      timeRange: timeRange ?? this.timeRange,
    );
  }

  @override
  List<Object?> get props => [bakeryInfo, stats, recentOrders, popularProducts, isOpen, timeRange];
}

class BakeryStatsLoading extends BakeryDashboardState {
  final String timeRange;

  const BakeryStatsLoading(this.timeRange);

  @override
  List<Object?> get props => [timeRange];
}

class BakeryStatusUpdateInProgress extends BakeryDashboardState {}

class BakeryStatusUpdateSuccess extends BakeryDashboardState {
  final bool isOpen;
  final String message;

  const BakeryStatusUpdateSuccess({
    required this.isOpen,
    required this.message,
  });

  @override
  List<Object?> get props => [isOpen, message];
}

class BakeryDashboardError extends BakeryDashboardState {
  final String message;

  const BakeryDashboardError(this.message);

  @override
  List<Object?> get props => [message];
}
