import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/utils/firebase_phone_helper.dart';

/// Status enum for OTP authentication flow
enum OtpAuthStatus { idle, sending, codeSent, verifying, verified, failed }

/// State class for Firebase OTP authentication
class FirebaseOtpState extends Equatable {
  final OtpAuthStatus status;
  final String? verificationId;
  final String? error;
  final int? resendToken;
  final String? phoneNumber;

  const FirebaseOtpState({
    this.status = OtpAuthStatus.idle,
    this.verificationId,
    this.error,
    this.resendToken,
    this.phoneNumber,
  });

  FirebaseOtpState copyWith({
    OtpAuthStatus? status,
    String? verificationId,
    String? error,
    int? resendToken,
    String? phoneNumber,
  }) {
    return FirebaseOtpState(
      status: status ?? this.status,
      verificationId: verificationId ?? this.verificationId,
      error: error ?? this.error,
      resendToken: resendToken ?? this.resendToken,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }

  @override
  List<Object?> get props =>
      [status, verificationId, error, resendToken, phoneNumber];
}

/// Cubit for handling Firebase Phone Authentication
///
/// This provides a simpler, Firebase-only OTP flow without backend integration.
/// Use this for pure Firebase auth, or as the first step before backend auth.
class FirebaseOtpCubit extends Cubit<FirebaseOtpState> {
  final FirebaseAuth _auth;

  FirebaseOtpCubit({FirebaseAuth? auth})
      : _auth = auth ?? FirebaseAuth.instance,
        super(const FirebaseOtpState());

  /// Send OTP to the provided phone number
  ///
  /// [phoneNumber] must be in E.164 format (e.g., +962777777777)
  /// [forceResendToken] can be provided for resend functionality
  Future<void> sendOtp(
    String phoneNumber, {
    int? forceResendToken,
  }) async {
    emit(state.copyWith(
      status: OtpAuthStatus.sending,
      error: null,
      phoneNumber: phoneNumber,
    ));

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        forceResendingToken: forceResendToken,
        timeout: const Duration(seconds: 60),

        // Auto-retrieval or instant verification on some devices
        verificationCompleted: (PhoneAuthCredential credential) async {
          try {
            print('DEBUG: Auto-verification completed');
            await _auth.signInWithCredential(credential);
            emit(state.copyWith(status: OtpAuthStatus.verified));
          } catch (e) {
            print('DEBUG: Auto-verification sign-in failed: $e');
            emit(state.copyWith(
              status: OtpAuthStatus.failed,
              error: e.toString(),
            ));
          }
        },

        // Verification failed
        verificationFailed: (FirebaseAuthException e) {
          print('DEBUG: Verification failed: ${e.code} - ${e.message}');
          String errorMessage = _getErrorMessage(e);
          emit(state.copyWith(
            status: OtpAuthStatus.failed,
            error: errorMessage,
          ));
        },

        // OTP code sent successfully
        codeSent: (String verificationId, int? resendToken) {
          print('DEBUG: Code sent. Verification ID: $verificationId');
          emit(state.copyWith(
            status: OtpAuthStatus.codeSent,
            verificationId: verificationId,
            resendToken: resendToken,
          ));
        },

        // Auto-retrieval timeout (user must enter code manually)
        codeAutoRetrievalTimeout: (String verificationId) {
          print(
              'DEBUG: Auto-retrieval timeout. Verification ID: $verificationId');
          // Keep the codeSent status, just update verification ID if needed
          if (state.status != OtpAuthStatus.codeSent) {
            emit(state.copyWith(
              status: OtpAuthStatus.codeSent,
              verificationId: verificationId,
            ));
          }
        },
      );
    } catch (e) {
      print('DEBUG: Exception during phone verification: $e');
      emit(state.copyWith(
        status: OtpAuthStatus.failed,
        error: e.toString(),
      ));
    }
  }

  /// Verify the OTP code entered by the user
  ///
  /// [smsCode] is the 6-digit code received via SMS
  Future<void> verifyOtp(String smsCode) async {
    if (state.verificationId == null) {
      emit(state.copyWith(
        status: OtpAuthStatus.failed,
        error: 'No verification ID available. Please request OTP again.',
      ));
      return;
    }

    emit(state.copyWith(status: OtpAuthStatus.verifying));

    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: state.verificationId!,
        smsCode: smsCode,
      );

      await _auth.signInWithCredential(credential);

      print('DEBUG: OTP verified successfully');
      emit(state.copyWith(status: OtpAuthStatus.verified));
    } on FirebaseAuthException catch (e) {
      print('DEBUG: OTP verification failed: ${e.code} - ${e.message}');
      String errorMessage = _getErrorMessage(e);
      emit(state.copyWith(
        status: OtpAuthStatus.failed,
        error: errorMessage,
      ));
    } catch (e) {
      print('DEBUG: OTP verification exception: $e');
      emit(state.copyWith(
        status: OtpAuthStatus.failed,
        error: e.toString(),
      ));
    }
  }

  /// Resend OTP using the stored resend token
  Future<void> resendOtp() async {
    if (state.phoneNumber == null) {
      emit(state.copyWith(
        status: OtpAuthStatus.failed,
        error: 'No phone number available. Please start over.',
      ));
      return;
    }

    await sendOtp(
      state.phoneNumber!,
      forceResendToken: state.resendToken,
    );
  }

  /// Get the currently authenticated Firebase user
  User? get currentUser => _auth.currentUser;

  /// Sign out from Firebase
  Future<void> signOut() async {
    await _auth.signOut();
    reset();
  }

  /// Reset the state to initial
  void reset() => emit(const FirebaseOtpState());

  /// Convert Firebase error codes to user-friendly messages
  String _getErrorMessage(FirebaseAuthException e) {
    return FirebasePhoneHelper.getErrorMessage(
      e.code,
      defaultMessage: e.message,
    );
  }
}
