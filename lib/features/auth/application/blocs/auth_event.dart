part of 'auth_bloc.dart';

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

  const LoginRequested({required this.emailOrPhone});

  @override
  List<Object?> get props => [emailOrPhone];
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
  final String verificationId;
  final String purpose; // registration, login, password_reset, etc.

  const OtpVerificationRequested({
    required this.otp,
    required this.verificationId,
    required this.purpose,
  });

  @override
  List<Object?> get props => [otp, verificationId, purpose];
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
  final String
      verificationId; // Changed from emailOrPhone to verificationId to match service method
  final String otp;
  final String newPassword;

  const ResetPasswordRequested({
    required this.verificationId,
    required this.otp,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [verificationId, otp, newPassword];
}

// Event for Logout
class LogoutRequested extends AuthEvent {}

// Event for Social Login (Example: Google)
class GoogleLoginRequested extends AuthEvent {}

// Event for Social Login (Example: Apple)
class AppleLoginRequested extends AuthEvent {}

// Event for File Upload
class FileUploadRequested extends AuthEvent {
  final String filePath;
  final String fileName;
  final String uploadType; // 'commercial_registry' or 'logo'

  const FileUploadRequested({
    required this.filePath,
    required this.fileName,
    required this.uploadType,
  });

  @override
  List<Object?> get props => [filePath, fileName, uploadType];
}

// Event for Bakery Registration (after user registration)
class BakeryRegistrationRequested extends AuthEvent {
  final String name;
  final String? description;
  final String addressLine1;
  final String? addressLine2;
  final String city;
  final String? postalCode;
  final String? country;
  final String phoneNumber;
  final String? email;
  final String? logoUrl;
  final String? coverImageUrl;
  final String? commercialRegistryUrl;
  final Map<String, dynamic>? operatingHours;

  const BakeryRegistrationRequested({
    required this.name,
    this.description,
    required this.addressLine1,
    this.addressLine2,
    required this.city,
    this.postalCode,
    this.country,
    required this.phoneNumber,
    this.email,
    this.logoUrl,
    this.coverImageUrl,
    this.commercialRegistryUrl,
    this.operatingHours,
  });

  @override
  List<Object?> get props => [
        name,
        description,
        addressLine1,
        addressLine2,
        city,
        postalCode,
        country,
        phoneNumber,
        email,
        logoUrl,
        coverImageUrl,
        commercialRegistryUrl,
        operatingHours,
      ];
}
