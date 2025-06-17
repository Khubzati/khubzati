part of '../blocs/auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

// Event to check initial auth status (e.g., on app start)
class AuthCheckRequested extends AuthEvent {}

// Event for Login
class LoginRequested extends AuthEvent {
  final String emailOrPhone;
  final String password;

  const LoginRequested({required this.emailOrPhone, required this.password});

  @override
  List<Object?> get props => [emailOrPhone, password];
}

// Event for Signup
class SignupRequested extends AuthEvent {
  final String username;
  final String email;
  final String phone;
  final String password;
  final String role; // To be passed from RoleSelectionBloc/UI

  const SignupRequested({
    required this.username,
    required this.email,
    required this.phone,
    required this.password,
    required this.role,
  });

  @override
  List<Object?> get props => [username, email, phone, password, role];
}

// Event for OTP Verification
class OtpVerificationRequested extends AuthEvent {
  final String otp;
  // May need additional context like phone number or verification ID from backend
  final String
      verificationId; // Example, adjust based on actual backend response

  const OtpVerificationRequested(
      {required this.otp, required this.verificationId});

  @override
  List<Object?> get props => [otp, verificationId];
}

// Event to request OTP for Forgot Password
class ForgotPasswordOtpRequested extends AuthEvent {
  final String emailOrPhone;

  const ForgotPasswordOtpRequested({required this.emailOrPhone});

  @override
  List<Object?> get props => [emailOrPhone];
}

// Event to verify OTP and reset password
class ResetPasswordRequested extends AuthEvent {
  final String emailOrPhone; // or verificationId
  final String otp;
  final String newPassword;

  const ResetPasswordRequested({
    required this.emailOrPhone,
    required this.otp,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [emailOrPhone, otp, newPassword];
}

// Event for Logout
class LogoutRequested extends AuthEvent {}

// Event for Social Login (Example: Google)
class GoogleLoginRequested extends AuthEvent {}

// Event for Social Login (Example: Apple)
class AppleLoginRequested extends AuthEvent {}
