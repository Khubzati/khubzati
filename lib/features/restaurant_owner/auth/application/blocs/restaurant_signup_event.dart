import 'package:equatable/equatable.dart';

abstract class RestaurantSignupEvent extends Equatable {
  const RestaurantSignupEvent();

  @override
  List<Object?> get props => [];
}

class RestaurantSignupRequested extends RestaurantSignupEvent {
  final String restaurantName;
  final String phoneNumber;
  final String location;
  final List<String> chefNames;
  final String? logoPath;
  final String? commercialRegisterPath;

  const RestaurantSignupRequested({
    required this.restaurantName,
    required this.phoneNumber,
    required this.location,
    required this.chefNames,
    this.logoPath,
    this.commercialRegisterPath,
  });

  @override
  List<Object?> get props => [
        restaurantName,
        phoneNumber,
        location,
        chefNames,
        logoPath,
        commercialRegisterPath,
      ];
}

class RestaurantOtpVerificationRequested extends RestaurantSignupEvent {
  final String phoneNumber;
  final String otp;

  const RestaurantOtpVerificationRequested({
    required this.phoneNumber,
    required this.otp,
  });

  @override
  List<Object?> get props => [phoneNumber, otp];
}

class RestaurantOtpResendRequested extends RestaurantSignupEvent {
  final String phoneNumber;

  const RestaurantOtpResendRequested(this.phoneNumber);

  @override
  List<Object?> get props => [phoneNumber];
}
