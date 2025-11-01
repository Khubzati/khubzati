import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:khubzati/features/restaurant_owner/auth/application/blocs/restaurant_signup_event.dart';
import 'package:khubzati/features/restaurant_owner/auth/application/blocs/restaurant_signup_state.dart';
import 'package:khubzati/features/restaurant_owner/auth/data/services/restaurant_auth_service.dart';

class RestaurantSignupBloc
    extends Bloc<RestaurantSignupEvent, RestaurantSignupState> {
  final RestaurantAuthService _authService;

  RestaurantSignupBloc({required RestaurantAuthService authService})
      : _authService = authService,
        super(const RestaurantSignupInitial()) {
    on<RestaurantSignupRequested>(_onRestaurantSignupRequested);
    on<RestaurantOtpVerificationRequested>(
        _onRestaurantOtpVerificationRequested);
    on<RestaurantOtpResendRequested>(_onRestaurantOtpResendRequested);
  }

  Future<void> _onRestaurantSignupRequested(
    RestaurantSignupRequested event,
    Emitter<RestaurantSignupState> emit,
  ) async {
    emit(const RestaurantSignupLoading());
    try {
      final verificationId = await _authService.signup(
        restaurantName: event.restaurantName,
        phoneNumber: event.phoneNumber,
        location: event.location,
        chefNames: event.chefNames,
        logoPath: event.logoPath,
        commercialRegisterPath: event.commercialRegisterPath,
      );
      emit(RestaurantSignupSuccess('Signup successful', verificationId));
    } catch (e) {
      emit(RestaurantSignupError('Signup failed: ${e.toString()}'));
    }
  }

  Future<void> _onRestaurantOtpVerificationRequested(
    RestaurantOtpVerificationRequested event,
    Emitter<RestaurantSignupState> emit,
  ) async {
    emit(const RestaurantSignupLoading());
    try {
      await _authService.verifyOtp(
        phoneNumber: event.phoneNumber,
        otp: event.otp,
      );
      emit(const RestaurantOtpVerified());
    } catch (e) {
      emit(RestaurantSignupError('OTP verification failed: ${e.toString()}'));
    }
  }

  Future<void> _onRestaurantOtpResendRequested(
    RestaurantOtpResendRequested event,
    Emitter<RestaurantSignupState> emit,
  ) async {
    emit(const RestaurantSignupLoading());
    try {
      await _authService.resendOtp(event.phoneNumber);
      emit(const RestaurantSignupSuccess('OTP resent successfully', ''));
    } catch (e) {
      emit(RestaurantSignupError('Failed to resend OTP: ${e.toString()}'));
    }
  }
}
