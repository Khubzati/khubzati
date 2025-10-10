import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:khubzati/core/services/auth_service.dart'; // Assuming this service exists
import 'package:khubzati/core/services/app_preferences.dart'; // Assuming this service exists
// import 'package:khubzati/core/models/user_model.dart'; // Assuming a User model

part 'auth_state.dart';
part 'auth_event.dart';

@injectable
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
    on<GoogleLoginRequested>(_onGoogleLoginRequested);
    on<AppleLoginRequested>(_onAppleLoginRequested);
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
      final loginResponse =
          await authService.login(event.emailOrPhone, event.password);
      await appPreferences.setUserToken(loginResponse['token']);
      await appPreferences.setUserId(loginResponse['user']['id']);
      await appPreferences.setUserRole(loginResponse['user']['role']);
      emit(Authenticated(
          userId: loginResponse['user']['id'],
          role: loginResponse['user']['role']));
    } catch (e) {
      emit(AuthError('Login failed: ${e.toString()}'));
    }
  }

  Future<void> _onSignupRequested(
      SignupRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final signupResponse = await authService.signup(
        username: event.username,
        email: event.email,
        phone: event.phone,
        password: event.password,
        role: event.role,
      );
      emit(OtpSent(
          verificationId: signupResponse['verification_id'],
          message: "OTP sent to ${event.phone}"));
    } catch (e) {
      emit(AuthError('Signup failed: ${e.toString()}'));
    }
  }

  Future<void> _onOtpVerificationRequested(
      OtpVerificationRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final otpResponse =
          await authService.verifyOtp(event.verificationId, event.otp);
      if (otpResponse['is_verified']) {
        // If OTP was for signup, token and user details might be returned here
        if (otpResponse['token'] != null) {
          await appPreferences.setUserToken(otpResponse['token']);
          await appPreferences.setUserId(otpResponse['user']['id']);
          await appPreferences.setUserRole(otpResponse['user']['role']);
          emit(Authenticated(
              userId: otpResponse['user']['id'],
              role: otpResponse['user']['role']));
        } else {
          // OTP verified but no token (e.g., for password reset)
          emit(OtpVerified(verificationId: event.verificationId));
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
      final response =
          await authService.requestPasswordResetOtp(event.emailOrPhone);
      emit(OtpSent(
          verificationId: response['verification_id'],
          message: "OTP sent to ${event.emailOrPhone}"));
    } catch (e) {
      emit(AuthError('Failed to request OTP: ${e.toString()}'));
    }
  }

  Future<void> _onResetPasswordRequested(
      ResetPasswordRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await authService.resetPassword(
        verificationId: event.verificationId,
        otp: event.otp,
        newPassword: event.newPassword,
      );
      emit(const PasswordResetSuccess(
          message: "Password reset successfully. Please login."));
    } catch (e) {
      emit(AuthError('Password reset failed: ${e.toString()}'));
    }
  }

  Future<void> _onLogoutRequested(
      LogoutRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await authService.logout(); // Call backend logout endpoint
      await appPreferences.clearUserSession(); // Clear token and user details
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthError('Logout failed: ${e.toString()}'));
    }
  }

  Future<void> _onGoogleLoginRequested(
      GoogleLoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      // TODO: Implement Google Sign-In using Firebase Auth
      // final googleUser = await GoogleSignIn().signIn();
      // if (googleUser != null) {
      //   final googleAuth = await googleUser.authentication;
      //   final credential = GoogleAuthProvider.credential(
      //     accessToken: googleAuth.accessToken,
      //     idToken: googleAuth.idToken,
      //   );
      //   final userCredential = await firebaseAuth.signInWithCredential(credential);
      //   // Handle successful login
      // }
      emit(const AuthError("Google Sign-In not implemented yet"));
    } catch (e) {
      emit(AuthError('Google Sign-In failed: ${e.toString()}'));
    }
  }

  Future<void> _onAppleLoginRequested(
      AppleLoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      // TODO: Implement Apple Sign-In using Firebase Auth
      // final appleCredential = await SignInWithApple.getAppleIDCredential(
      //   scopes: [
      //     AppleIDAuthorizationScopes.email,
      //     AppleIDAuthorizationScopes.fullName,
      //   ],
      // );
      // final oauthCredential = OAuthProvider("apple.com").credential(
      //   idToken: appleCredential.identityToken,
      //   accessToken: appleCredential.authorizationCode,
      // );
      // final userCredential = await firebaseAuth.signInWithCredential(oauthCredential);
      // // Handle successful login
      emit(const AuthError("Apple Sign-In not implemented yet"));
    } catch (e) {
      emit(AuthError('Apple Sign-In failed: ${e.toString()}'));
    }
  }
}
