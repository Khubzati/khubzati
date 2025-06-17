part of 'profile_bloc.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  // final UserModel user;
  final Map<String, dynamic> user;
  final List<Map<String, dynamic>> addresses;
  final String currentLanguage;

  const ProfileLoaded({
    required this.user,
    required this.addresses,
    required this.currentLanguage,
  });

  @override
  List<Object?> get props => [user, addresses, currentLanguage];
}

class ProfileUpdateInProgress extends ProfileState {}

class ProfileUpdateSuccess extends ProfileState {
  final String message;

  const ProfileUpdateSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class PasswordChangeInProgress extends ProfileState {}

class PasswordChangeSuccess extends ProfileState {
  final String message;

  const PasswordChangeSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class AddressManagementState extends ProfileState {
  final List<Map<String, dynamic>> addresses;

  const AddressManagementState(this.addresses);

  @override
  List<Object?> get props => [addresses];
}

class AddressOperationInProgress extends ProfileState {}

class AddressOperationSuccess extends ProfileState {
  final String message;
  final String operationType; // "add", "update", "delete", "set_default"

  const AddressOperationSuccess({
    required this.message,
    required this.operationType,
  });

  @override
  List<Object?> get props => [message, operationType];
}

class LanguageChangeInProgress extends ProfileState {}

class LanguageChangeSuccess extends ProfileState {
  final String languageCode;

  const LanguageChangeSuccess(this.languageCode);

  @override
  List<Object?> get props => [languageCode];
}

class LogoutInProgress extends ProfileState {}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError(this.message);

  @override
  List<Object?> get props => [message];
}
