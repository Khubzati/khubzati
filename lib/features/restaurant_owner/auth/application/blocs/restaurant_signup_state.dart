import 'package:equatable/equatable.dart';

class RestaurantSignupState extends Equatable {
  const RestaurantSignupState();

  @override
  List<Object?> get props => [];
}

class RestaurantSignupInitial extends RestaurantSignupState {
  const RestaurantSignupInitial();
}

class RestaurantSignupLoading extends RestaurantSignupState {
  const RestaurantSignupLoading();
}

class RestaurantSignupSuccess extends RestaurantSignupState {
  final String message;
  final String verificationId;

  const RestaurantSignupSuccess(this.message, this.verificationId);

  @override
  List<Object?> get props => [message, verificationId];
}

class RestaurantOtpVerified extends RestaurantSignupState {
  const RestaurantOtpVerified();
}

class RestaurantSignupError extends RestaurantSignupState {
  final String message;

  const RestaurantSignupError(this.message);

  @override
  List<Object?> get props => [message];
}
