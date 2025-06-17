import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
// Import your models and services here
// e.g., import 'package:khubzati/core/models/restaurant_model.dart';
// import 'package:khubzati/core/services/restaurant_service.dart';
// import 'package:khubzati/core/services/order_service.dart';

part 'restaurant_dashboard_event.dart';
part 'restaurant_dashboard_state.dart';

class RestaurantDashboardBloc extends Bloc<RestaurantDashboardEvent, RestaurantDashboardState> {
  // final RestaurantService restaurantService;
  // final OrderService orderService;

  RestaurantDashboardBloc(/*{
    required this.restaurantService,
    required this.orderService,
  }*/) : super(RestaurantDashboardInitial()) {
    on<LoadRestaurantDashboard>(_onLoadRestaurantDashboard);
    on<FetchRestaurantStats>(_onFetchRestaurantStats);
    on<FetchRecentOrders>(_onFetchRecentOrders);
    on<FetchPopularDishes>(_onFetchPopularDishes);
    on<UpdateRestaurantStatus>(_onUpdateRestaurantStatus);
  }

  Future<void> _onLoadRestaurantDashboard(LoadRestaurantDashboard event, Emitter<RestaurantDashboardState> emit) async {
    emit(RestaurantDashboardLoading());
    try {
      // TODO: Replace with actual API calls
      // final restaurantInfo = await restaurantService.getRestaurantInfo();
      // final stats = await restaurantService.getRestaurantStats(timeRange: 'today');
      // final recentOrders = await orderService.getRecentOrders(limit: 10);
      // final popularDishes = await restaurantService.getPopularDishes(limit: 5);
      // final isOpen = restaurantInfo.isOpen;

      // Placeholder data
      await Future.delayed(const Duration(milliseconds: 800));
      final restaurantInfo = {
        'id': 'restaurant123',
        'name': 'Delicious Bites Restaurant',
        'address': '456 Food Street, Riyadh',
        'phone': '+966 50 987 6543',
        'email': 'info@deliciousbites.com',
        'logo': 'https://example.com/restaurant_logo.jpg',
        'rating': 4.7,
        'reviewCount': 98,
        'cuisineType': 'Middle Eastern',
      };

      final stats = {
        'timeRange': 'today',
        'totalOrders': 32,
        'totalRevenue': 1850.75,
        'pendingOrders': 7,
        'completedOrders': 25,
        'averageOrderValue': 57.83,
        'topSellingCategory': 'Main Dishes',
      };

      final recentOrders = List.generate(5, (index) => {
        'id': 'ORD200${index + 1}',
        'customerName': 'Customer ${index + 1}',
        'orderTime': DateTime.now().subtract(Duration(hours: index)).toString(),
        'status': index % 3 == 0 ? 'completed' : (index % 3 == 1 ? 'in_progress' : 'pending'),
        'total': 60.0 + (index * 10.0),
        'items': [
          {
            'name': 'Shawarma Plate',
            'quantity': 2,
            'price': 15.99,
          },
          {
            'name': 'Hummus',
            'quantity': 1,
            'price': 5.99,
          },
        ],
      });

      final popularDishes = List.generate(5, (index) => {
        'id': 'dish${index + 1}',
        'name': 'Dish ${index + 1}',
        'price': 12.0 + (index * 3.0),
        'soldCount': 120 - (index * 15),
        'rating': 5.0 - (index * 0.1),
        'image': 'https://example.com/dish${index + 1}.jpg',
      });

      const isOpen = true;

      emit(RestaurantDashboardLoaded(
        restaurantInfo: restaurantInfo,
        stats: stats,
        recentOrders: recentOrders,
        popularDishes: popularDishes,
        isOpen: isOpen,
        timeRange: 'today',
      ));
    } catch (e) {
      emit(RestaurantDashboardError('Failed to load dashboard: ${e.toString()}'));
    }
  }

  Future<void> _onFetchRestaurantStats(FetchRestaurantStats event, Emitter<RestaurantDashboardState> emit) async {
    if (state is RestaurantDashboardLoaded) {
      final currentState = state as RestaurantDashboardLoaded;
      emit(RestaurantStatsLoading(event.timeRange));
      
      try {
        // TODO: Replace with actual API call
        // final stats = await restaurantService.getRestaurantStats(timeRange: event.timeRange);

        // Placeholder data
        await Future.delayed(const Duration(milliseconds: 600));
        final stats = {
          'timeRange': event.timeRange,
          'totalOrders': event.timeRange == 'today' ? 32 : 
                        event.timeRange == 'week' ? 198 : 
                        event.timeRange == 'month' ? 850 : 3200,
          'totalRevenue': event.timeRange == 'today' ? 1850.75 : 
                         event.timeRange == 'week' ? 11500.50 : 
                         event.timeRange == 'month' ? 49000.00 : 180000.00,
          'pendingOrders': event.timeRange == 'today' ? 7 : 
                          event.timeRange == 'week' ? 15 : 
                          event.timeRange == 'month' ? 30 : 0,
          'completedOrders': event.timeRange == 'today' ? 25 : 
                            event.timeRange == 'week' ? 183 : 
                            event.timeRange == 'month' ? 820 : 3200,
          'averageOrderValue': event.timeRange == 'today' ? 57.83 : 
                              event.timeRange == 'week' ? 58.08 : 
                              event.timeRange == 'month' ? 57.65 : 56.25,
          'topSellingCategory': event.timeRange == 'today' ? 'Main Dishes' : 
                               event.timeRange == 'week' ? 'Main Dishes' : 
                               event.timeRange == 'month' ? 'Appetizers' : 'Beverages',
        };

        emit(currentState.copyWith(
          stats: stats,
          timeRange: event.timeRange,
        ));
      } catch (e) {
        emit(RestaurantDashboardError('Failed to fetch stats: ${e.toString()}'));
        // Revert to previous state after error
        emit(currentState);
      }
    }
  }

  Future<void> _onFetchRecentOrders(FetchRecentOrders event, Emitter<RestaurantDashboardState> emit) async {
    if (state is RestaurantDashboardLoaded) {
      final currentState = state as RestaurantDashboardLoaded;
      // Could emit a specific loading state for orders, but for simplicity using the main state
      
      try {
        // TODO: Replace with actual API call
        // final recentOrders = await orderService.getRecentOrders(
        //   limit: event.limit,
        //   page: event.page,
        // );

        // Placeholder data
        await Future.delayed(const Duration(milliseconds: 500));
        final recentOrders = List.generate(event.limit, (index) => {
          'id': 'ORD${event.page}${index + 1}',
          'customerName': 'Customer ${(event.page - 1) * event.limit + index + 1}',
          'orderTime': DateTime.now().subtract(Duration(hours: (event.page - 1) * event.limit + index)).toString(),
          'status': index % 3 == 0 ? 'completed' : (index % 3 == 1 ? 'in_progress' : 'pending'),
          'total': 60.0 + (index * 10.0),
          'items': [
            {
              'name': 'Shawarma Plate',
              'quantity': 2,
              'price': 15.99,
            },
            {
              'name': 'Hummus',
              'quantity': 1,
              'price': 5.99,
            },
          ],
        });

        emit(currentState.copyWith(
          recentOrders: recentOrders,
        ));
      } catch (e) {
        emit(RestaurantDashboardError('Failed to fetch recent orders: ${e.toString()}'));
        // Revert to previous state after error
        emit(currentState);
      }
    }
  }

  Future<void> _onFetchPopularDishes(FetchPopularDishes event, Emitter<RestaurantDashboardState> emit) async {
    if (state is RestaurantDashboardLoaded) {
      final currentState = state as RestaurantDashboardLoaded;
      // Could emit a specific loading state for dishes, but for simplicity using the main state
      
      try {
        // TODO: Replace with actual API call
        // final popularDishes = await restaurantService.getPopularDishes(limit: event.limit);

        // Placeholder data
        await Future.delayed(const Duration(milliseconds: 400));
        final popularDishes = List.generate(event.limit, (index) => {
          'id': 'dish${index + 1}',
          'name': 'Popular Dish ${index + 1}',
          'price': 12.0 + (index * 3.0),
          'soldCount': 120 - (index * 15),
          'rating': 5.0 - (index * 0.1),
          'image': 'https://example.com/dish${index + 1}.jpg',
        });

        emit(currentState.copyWith(
          popularDishes: popularDishes,
        ));
      } catch (e) {
        emit(RestaurantDashboardError('Failed to fetch popular dishes: ${e.toString()}'));
        // Revert to previous state after error
        emit(currentState);
      }
    }
  }

  Future<void> _onUpdateRestaurantStatus(UpdateRestaurantStatus event, Emitter<RestaurantDashboardState> emit) async {
    if (state is RestaurantDashboardLoaded) {
      final currentState = state as RestaurantDashboardLoaded;
      emit(RestaurantStatusUpdateInProgress());
      
      try {
        // TODO: Replace with actual API call
        // await restaurantService.updateRestaurantStatus(isOpen: event.isOpen);

        // Placeholder: simulate API call
        await Future.delayed(const Duration(milliseconds: 500));
        
        final message = event.isOpen ? 'Restaurant is now open for orders' : 'Restaurant is now closed';
        emit(RestaurantStatusUpdateSuccess(isOpen: event.isOpen, message: message));
        
        // Update the main state
        emit(currentState.copyWith(isOpen: event.isOpen));
      } catch (e) {
        emit(RestaurantDashboardError('Failed to update restaurant status: ${e.toString()}'));
        // Revert to previous state after error
        emit(currentState);
      }
    }
  }
}
