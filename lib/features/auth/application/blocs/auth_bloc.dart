import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:khubzati/core/services/auth_service.dart'; // Assuming this service exists
import 'package:khubzati/core/services/app_preferences.dart'; // Assuming this service exists
// import 'package:khubzati/core/models/user_model.dart'; // Assuming a User model

part '../states/auth_state.dart';
part '../events/auth_event.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService authService;
  final AppPreferences appPreferences;

  AuthBloc({required this.authService, required this.appPreferences})
      : super(AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<LoginRequested>(_onLoginRequested);
    on<SignupRequested>(_onSignupRequested);
    on<OtpVerificationRequested>(_onOtpVerificationRequested);
    on<ForgotPasswordOtpRequested>(_onForgotPasswordOtpRequested);
    on<ResetPasswordRequested>(_onResetPasswordRequested);
    on<LogoutRequested>(_onLogoutRequested);
    // TODO: Add handlers for social login events (GoogleLoginRequested, AppleLoginRequested)
  }

  Future<void> _onAuthCheckRequested(
      AuthCheckRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final token = await appPreferences.getUserToken();
      if (token != null && token.isNotEmpty) {
        // Optionally, verify token with backend here or fetch user details
        final userId = await appPreferences.getUserId(); // Example
        final userRole = await appPreferences.getUserRole(); // Example
        if (userId != null && userRole != null) {
          emit(Authenticated(userId: userId, role: userRole));
        } else {
          // Token exists but user details are missing, might need to re-fetch or logout
          await appPreferences.clearUserSession();
          emit(Unauthenticated());
        }
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(AuthError('Failed to check authentication status: ${e.toString()}'));
    }
  }

  Future<void> _onLoginRequested(
      LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      // TODO: Replace with actual API call from authService
      // final loginResponse = await authService.login(event.emailOrPhone, event.password);
      // await appPreferences.setUserToken(loginResponse.token);
      // await appPreferences.setUserId(loginResponse.user.id);
      // await appPreferences.setUserRole(loginResponse.user.role);
      // emit(Authenticated(userId: loginResponse.user.id, role: loginResponse.user.role));

      // Placeholder logic until API integration
      await Future.delayed(
          const Duration(seconds: 1)); // Simulate network delay
      if (event.emailOrPhone == "test@example.com" &&
          event.password == "password") {
        const placeholderUserId = "user123";
        const placeholderRole = "customer"; // or determine from login response
        await appPreferences.setUserToken("fake_token_123");
        await appPreferences.setUserId(placeholderUserId);
        await appPreferences.setUserRole(placeholderRole);
        emit(Authenticated(userId: placeholderUserId, role: placeholderRole));
      } else {
        emit(const AuthError("Invalid credentials. Please try again."));
      }
    } catch (e) {
      emit(AuthError('Login failed: ${e.toString()}'));
    }
  }

  Future<void> _onSignupRequested(
      SignupRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      // TODO: Replace with actual API call from authService for signup
      // final signupResponse = await authService.signup(
      //   username: event.username,
      //   email: event.email,
      //   phone: event.phone,
      //   password: event.password,
      //   role: event.role,
      // );
      // emit(OtpSent(verificationId: signupResponse.verificationId, message: "OTP sent to ${event.phone}"));

      // Placeholder logic
      await Future.delayed(const Duration(seconds: 1));
      emit(const OtpSent(
          verificationId: "signup_otp_123",
          message: "OTP sent to your phone for signup."));
    } catch (e) {
      emit(AuthError('Signup failed: ${e.toString()}'));
    }
  }

  Future<void> _onOtpVerificationRequested(
      OtpVerificationRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      // TODO: Replace with actual API call from authService to verify OTP
      // final otpResponse = await authService.verifyOtp(event.verificationId, event.otp);
      // if (otpResponse.isVerified) {
      //   // If OTP was for signup, token and user details might be returned here or require another step
      //   // For simplicity, assuming it leads to Authenticated state for now
      //   await appPreferences.setUserToken(otpResponse.token); 
      //   await appPreferences.setUserId(otpResponse.user.id);
      //   await appPreferences.setUserRole(otpResponse.user.role);
      //   emit(Authenticated(userId: otpResponse.user.id, role: otpResponse.user.role));
      // } else {
      //   emit(const AuthError("Invalid OTP. Please try again."));
      // }

      // Placeholder logic
      await Future.delayed(const Duration(seconds: 1));
      if (event.otp == "123456") {
         // Check if this OTP was for signup or password reset based on verificationId or state
        if (event.verificationId.startsWith("signup")) {
            const placeholderUserId = "user_signup_123";
          const placeholderRole =
              "customer"; // Role should be known from signup request
            await appPreferences.setUserToken("fake_signup_token_123");
            await appPreferences.setUserId(placeholderUserId);
            await appPreferences.setUserRole(placeholderRole);
            emit(Authenticated(userId: placeholderUserId, role: placeholderRole));
        } else if (event.verificationId.startsWith("reset")) {
          emit(OtpVerified(
              verificationId: event
                  .verificationId)); // Transition to allow new password entry
        }
      } else {
        emit(const AuthError("Invalid OTP. Please try again."));
      }
    } catch (e) {
      emit(AuthError('OTP verification failed: ${e.toString()}'));
    }
  }

  Future<void> _onForgotPasswordOtpRequested(
      ForgotPasswordOtpRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      // TODO: Replace with actual API call from authService to request OTP for password reset
      // final response = await authService.requestPasswordResetOtp(event.emailOrPhone);
      // emit(OtpSent(verificationId: response.verificationId, message: "OTP sent to ${event.emailOrPhone}"));

      // Placeholder logic
      await Future.delayed(const Duration(seconds: 1));
      emit(const OtpSent(
          verificationId: "reset_otp_123",
          message: "OTP for password reset sent."));
    } catch (e) {
      emit(AuthError('Failed to request OTP: ${e.toString()}'));
    }
  }

  Future<void> _onResetPasswordRequested(
      ResetPasswordRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      // TODO: Replace with actual API call from authService to reset password
      // await authService.resetPassword(
      //   verificationId: event.emailOrPhone, // or the verificationId from OtpSent state
      //   otp: event.otp,
      //   newPassword: event.newPassword,
      // );
      // emit(const PasswordResetSuccess(message: "Password reset successfully. Please login."));

      // Placeholder logic
      await Future.delayed(const Duration(seconds: 1));
      // Assuming OTP was already verified and we are in a state to accept new password
      emit(const PasswordResetSuccess(
          message: "Password has been reset successfully. Please login."));
    } catch (e) {
      emit(AuthError('Password reset failed: ${e.toString()}'));
    }
  }

  Future<void> _onLogoutRequested(
      LogoutRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      // TODO: Call authService.logout() if there's a backend logout endpoint
      await appPreferences.clearUserSession(); // Clear token and user details
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthError('Logout failed: ${e.toString()}'));
    }
  }
}
