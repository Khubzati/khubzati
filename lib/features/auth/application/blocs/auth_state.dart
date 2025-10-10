part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

// Initial state, before any auth check
class AuthInitial extends AuthState {}

// When authentication process is in progress (e.g., API call)
class AuthLoading extends AuthState {}

// When user is authenticated
class Authenticated extends AuthState {
  // final User user; // Assuming a User model exists
  final String userId; // Or user token, or user object
  final String role; // User role (customer, bakery_owner, restaurant_owner)

  const Authenticated({required this.userId, required this.role});

  @override
  List<Object?> get props => [userId, role];
}

// When user is not authenticated
class Unauthenticated extends AuthState {}

// When an authentication error occurs
class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

// State when OTP has been sent (e.g., for signup or forgot password)
class OtpSent extends AuthState {
  final String verificationId; // Or some identifier for the OTP process
  final String? message; // Optional message e.g. "OTP sent to your phone"

  const OtpSent({required this.verificationId, this.message});

  @override
  List<Object?> get props => [verificationId, message];
}

// State when OTP verification is successful (intermediate state before Authenticated or PasswordResetReady)
class OtpVerified extends AuthState {
  final String verificationId; // Or some identifier for the OTP process

  const OtpVerified({required this.verificationId});
  @override
  List<Object?> get props => [verificationId];
}

// State when password reset is successful and user can login
class PasswordResetSuccess extends AuthState {
  final String? message; // Optional success message

  const PasswordResetSuccess({this.message});

  @override
  List<Object?> get props => [message];
}

// State when file upload is in progress
class FileUploadLoading extends AuthState {
  final String uploadType;

  const FileUploadLoading({required this.uploadType});

  @override
  List<Object?> get props => [uploadType];
}

// State when file upload is successful
class FileUploadSuccess extends AuthState {
  final String fileName;
  final String uploadType;
  final String? fileUrl; // URL returned from server

  const FileUploadSuccess({
    required this.fileName,
    required this.uploadType,
    this.fileUrl,
  });

  @override
  List<Object?> get props => [fileName, uploadType, fileUrl];
}

// State when file upload fails
class FileUploadError extends AuthState {
  final String message;
  final String uploadType;

  const FileUploadError({
    required this.message,
    required this.uploadType,
  });

  @override
  List<Object?> get props => [message, uploadType];
}
