part of 'profile_bloc.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileUpdateInProgress extends ProfileState {}

class PasswordChangeInProgress extends ProfileState {}

class AddressOperationInProgress extends ProfileState {}

class LanguageChangeInProgress extends ProfileState {}

class NotificationPreferencesUpdateInProgress extends ProfileState {}

class LogoutInProgress extends ProfileState {}

class ProfileUpdateSuccess extends ProfileState {
  final String message;

  const ProfileUpdateSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class PasswordChangeSuccess extends ProfileState {
  final String message;

  const PasswordChangeSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class AddressOperationSuccess extends ProfileState {
  final String message;
  final String operationType;

  const AddressOperationSuccess({
    required this.message,
    required this.operationType,
  });

  @override
  List<Object?> get props => [message, operationType];
}

class LanguageChangeSuccess extends ProfileState {
  final String languageCode;

  const LanguageChangeSuccess(this.languageCode);

  @override
  List<Object?> get props => [languageCode];
}

class NotificationPreferencesUpdateSuccess extends ProfileState {
  final String message;

  const NotificationPreferencesUpdateSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class LogoutSuccess extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final Map<String, dynamic> user;
  final List<Map<String, dynamic>> addresses;
  final List<Map<String, dynamic>> paymentMethods;
  final String currentLanguage;

  const ProfileLoaded({
    required this.user,
    required this.addresses,
    required this.paymentMethods,
    required this.currentLanguage,
  });

  @override
  List<Object?> get props => [user, addresses, paymentMethods, currentLanguage];
}

class AddressManagementState extends ProfileState {
  final List<Map<String, dynamic>> addresses;

  const AddressManagementState(this.addresses);

  @override
  List<Object?> get props => [addresses];
}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError(this.message);

  @override
  List<Object?> get props => [message];
}