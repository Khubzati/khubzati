import 'package:injectable/injectable.dart';

@injectable
class RestaurantAuthService {
  Future<String> signup({
    required String restaurantName,
    required String phoneNumber,
    required String location,
    required List<String> chefNames,
    String? logoPath,
    String? commercialRegisterPath,
  }) async {
    // TODO: Mock implementation for development
    await Future.delayed(const Duration(seconds: 2));

    // Simulate API call
    return 'verification_id_${DateTime.now().millisecondsSinceEpoch}';
  }

  Future<void> verifyOtp({
    required String phoneNumber,
    required String otp,
  }) async {
    // TODO: Mock implementation for development
    await Future.delayed(const Duration(seconds: 1));

    // Simulate OTP verification
    if (otp != '123456') {
      throw Exception('Invalid OTP');
    }
  }

  Future<void> resendOtp(String phoneNumber) async {
    // TODO: Mock implementation for development
    await Future.delayed(const Duration(seconds: 1));

    // Simulate OTP resend
  }
}
