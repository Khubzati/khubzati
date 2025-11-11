import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:khubzati/features/auth/data/services/auth_service.dart';
import 'package:khubzati/core/services/app_preferences.dart'; // Assuming this service exists
import 'package:khubzati/core/api/api_error.dart'; // For ApiError type
// import 'package:khubzati/core/models/user_model.dart'; // Assuming a User model

part 'auth_state.dart';
part 'auth_event.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService authService;
  final AppPreferences appPreferences;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

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
    on<BakeryRegistrationRequested>(_onBakeryRegistrationRequested);
    on<FileUploadRequested>(_onFileUploadRequested);
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
      final loginResponse = await authService.login(
        emailOrPhone: event.emailOrPhone,
      );

      final responseData = loginResponse['data'] ?? loginResponse;
      final verificationId =
          responseData['verificationId'] ?? event.emailOrPhone;
      final message = loginResponse['message'] as String? ??
          'OTP sent to ${event.emailOrPhone}';

      // Extract and print OTP if available from backend (development mode)
      final otp = responseData['otp'];
      if (otp != null) {
        print('═══════════════════════════════════════════════════════════');
        print('🔐 BACKEND OTP RECEIVED IN FLUTTER APP');
        print('═══════════════════════════════════════════════════════════');
        print('📱 Phone/Email: ${event.emailOrPhone}');
        print('🆔 Verification ID: $verificationId');
        print('🔑 OTP CODE: $otp');
        print('⏰ Expires At: ${responseData['expiresAt'] ?? 'N/A'}');
        print('💡 Use this code to verify OTP in the app');
        print('═══════════════════════════════════════════════════════════');
      }

      emit(OtpSent(
        verificationId: verificationId,
        purpose: 'login',
        contact: event.emailOrPhone,
        message: message,
      ));
    } catch (e) {
      if (e is ApiError) {
        final errorData = e.data;
        final errorMessage = (errorData is Map && errorData['message'] != null)
            ? errorData['message'] as String
            : e.message;
        emit(AuthError(errorMessage));
      } else {
        emit(AuthError('Login failed: ${e.toString()}'));
      }
    }
  }

  Future<void> _onSignupRequested(
      SignupRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final signupResponse = await authService.register(
        name: event.username,
        email: event.email,
        phone: event.phone,
        password: event.password,
        role: event.role,
      );
      emit(OtpSent(
        verificationId: signupResponse['verification_id'],
        purpose: 'registration',
        contact: event.phone,
        message: "OTP sent to ${event.phone}",
      ));
    } catch (e) {
      emit(AuthError('Signup failed: ${e.toString()}'));
    }
  }

  Future<void> _onOtpVerificationRequested(
      OtpVerificationRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      if (event.purpose == 'login') {
        final loginResponse = await authService.login(
          emailOrPhone: event.verificationId,
          otp: event.otp,
        );

        final responseData = loginResponse['data'] ?? loginResponse;
        final token = responseData['token'] ?? loginResponse['token'];
        final user = responseData['user'] ?? loginResponse['user'];

        if (token != null) {
          // Save token to both AppPreferences and FlutterSecureStorage
          // AppPreferences is used by the app, FlutterSecureStorage is used by AuthInterceptor
          await appPreferences.setUserToken(token);
          await _secureStorage.write(key: 'auth_token', value: token);
        }

        if (user is Map) {
          // Extract user info from response
          final userId = user['id']?.toString() ?? '';

          // Try to get role from user object first, then from JWT token as fallback
          String userRole = user['role']?.toString() ?? '';

          // Debug: Print user object to see what we're receiving
          print('DEBUG: User object from login response: $user');
          print('DEBUG: Role from user object: $userRole');

          // If role is missing from user object, try to decode from JWT token
          if (userRole.isEmpty && token != null) {
            try {
              final decoded = JwtDecoder.decode(token);
              userRole = decoded['role']?.toString() ?? '';
              print('DEBUG: Role from JWT token: $userRole');
            } catch (e) {
              print('Error decoding JWT token: $e');
            }
          }

          if (userId.isNotEmpty) {
            await appPreferences.setUserId(userId);
          }
          if (userRole.isNotEmpty) {
            await appPreferences.setUserRole(userRole);
            print('DEBUG: Saved user role to preferences: $userRole');
          } else {
            // If still no role, this is an error
            print('DEBUG ERROR: No role found in user object or JWT token');
            print('DEBUG: Full login response: $loginResponse');
            emit(const AuthError('Login failed: user role not found.'));
            return;
          }

          emit(Authenticated(userId: userId, role: userRole));
        } else {
          print('DEBUG ERROR: User is not a Map, type: ${user.runtimeType}');
          print('DEBUG: Full login response: $loginResponse');
          emit(const AuthError('Login failed: missing user information.'));
        }
        return;
      }

      final otpResponse = await authService.verifyOtp(
        emailOrPhone: event.verificationId,
        otp: event.otp,
        verificationPurpose: event.purpose,
      );

      if (event.purpose == 'registration') {
        if (otpResponse['is_verified']) {
          if (otpResponse['token'] != null) {
            final token = otpResponse['token'];
            // Save token to both AppPreferences and FlutterSecureStorage
            await appPreferences.setUserToken(token);
            await _secureStorage.write(key: 'auth_token', value: token);
            await appPreferences.setUserId(otpResponse['user']['id']);
            await appPreferences.setUserRole(otpResponse['user']['role']);

            final userRole = otpResponse['user']['role'];
            final userId = otpResponse['user']['id'];

            if (userRole == 'bakery_owner') {
              try {
                final pendingBakeryData =
                    await appPreferences.getPendingBakeryData();

                if (pendingBakeryData != null && pendingBakeryData.isNotEmpty) {
                  final bakeryName =
                      pendingBakeryData['bakeryName']?.toString() ?? '';
                  final location =
                      pendingBakeryData['location']?.toString() ?? '';
                  final phoneNumber =
                      pendingBakeryData['phone']?.toString() ?? '';
                  final email = pendingBakeryData['email']?.toString();

                  if (bakeryName.isNotEmpty && location.isNotEmpty) {
                    try {
                      await authService.registerBakery(
                        name: bakeryName,
                        addressLine1: location,
                        city: location,
                        phoneNumber: phoneNumber.isNotEmpty
                            ? phoneNumber
                            : otpResponse['user']?['phoneNumber'] ?? '',
                        email: email,
                        logoUrl: pendingBakeryData['logo']?.toString(),
                        commercialRegistryUrl:
                            pendingBakeryData['commercialRegistry']?.toString(),
                        description:
                            pendingBakeryData['description']?.toString(),
                      );
                      await appPreferences.clearPendingBakeryData();
                    } catch (e) {
                      print('Bakery registration error: $e');
                    }
                  }
                }
              } catch (e) {
                print('Error checking pending bakery data: $e');
              }
            }

            emit(Authenticated(userId: userId, role: userRole));
          } else {
            emit(OtpVerified(verificationId: event.verificationId));
          }
        } else {
          emit(const AuthError('Invalid OTP. Please try again.'));
        }
        return;
      }

      // Default behaviour (e.g., password reset flows)
      emit(OtpVerified(verificationId: event.verificationId));
    } catch (e) {
      if (e is ApiError) {
        final errorData = e.data;
        final errorMessage = (errorData is Map && errorData['message'] != null)
            ? errorData['message'] as String
            : e.message;
        emit(AuthError(errorMessage));
      } else {
        emit(AuthError('OTP verification failed: ${e.toString()}'));
      }
    }
  }

  Future<void> _onFileUploadRequested(
      FileUploadRequested event, Emitter<AuthState> emit) async {
    emit(FileUploadLoading(uploadType: event.uploadType));
    try {
      final response = await authService.uploadFile(
        filePath: event.filePath,
        fileName: event.fileName,
      );

      final responseData = response['data'] ?? response;
      final fileUrl = responseData['fileUrl'] as String?;

      emit(FileUploadSuccess(
        fileName: event.fileName,
        uploadType: event.uploadType,
        fileUrl: fileUrl,
      ));
    } catch (e) {
      emit(FileUploadError(
        message: 'File upload failed: ${e.toString()}',
        uploadType: event.uploadType,
      ));
    }
  }

  Future<void> _onBakeryRegistrationRequested(
      BakeryRegistrationRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await authService.registerBakery(
        name: event.name,
        description: event.description,
        addressLine1: event.addressLine1,
        addressLine2: event.addressLine2,
        city: event.city,
        postalCode: event.postalCode,
        country: event.country,
        phoneNumber: event.phoneNumber,
        email: event.email,
        logoUrl: event.logoUrl,
        coverImageUrl: event.coverImageUrl,
        commercialRegistryUrl: event.commercialRegistryUrl,
        operatingHours: event.operatingHours,
      );
      emit(const BakeryRegistrationSuccess(
          message:
              'Bakery registration submitted successfully. Awaiting admin approval.'));
    } catch (e) {
      emit(AuthError('Bakery registration failed: ${e.toString()}'));
    }
  }

  Future<void> _onForgotPasswordOtpRequested(
      ForgotPasswordOtpRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final response = await authService.forgotPassword(
        emailOrPhone: event.emailOrPhone,
      );

      // Extract and print OTP if available from backend (development mode)
      final responseData = response['data'] ?? response;
      final otp = responseData['otp'];
      if (otp != null) {
        print('═══════════════════════════════════════════════════════════');
        print('🔐 BACKEND OTP RECEIVED (PASSWORD RESET)');
        print('═══════════════════════════════════════════════════════════');
        print('📱 Phone/Email: ${event.emailOrPhone}');
        print(
            '🆔 Verification ID: ${responseData['verificationId'] ?? response['verification_id']}');
        print('🔑 OTP CODE: $otp');
        print('⏰ Expires At: ${responseData['expiresAt'] ?? 'N/A'}');
        print('💡 Use this code to reset your password');
        print('═══════════════════════════════════════════════════════════');
      }

      emit(OtpSent(
        verificationId:
            responseData['verificationId'] ?? response['verification_id'],
        purpose: 'password_reset',
        contact: event.emailOrPhone,
        message: "OTP sent to ${event.emailOrPhone}",
      ));
    } catch (e) {
      emit(AuthError('Failed to request OTP: ${e.toString()}'));
    }
  }

  Future<void> _onResetPasswordRequested(
      ResetPasswordRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await authService.resetPassword(
        emailOrPhone: event.verificationId,
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
      // Also clear token from FlutterSecureStorage
      await _secureStorage.delete(key: 'auth_token');
      await _secureStorage.delete(key: 'refresh_token');
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
