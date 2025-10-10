part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadUserProfile extends ProfileEvent {
  const LoadUserProfile();
}

class UpdateUserProfile extends ProfileEvent {
  final String? name;
  final String? email;
  final String? phone;

  const UpdateUserProfile({
    this.name,
    this.email,
    this.phone,
  });

  @override
  List<Object?> get props => [name, email, phone];
}

class ChangePassword extends ProfileEvent {
  final String currentPassword;
  final String newPassword;
  final String confirmPassword;

  const ChangePassword({
    required this.currentPassword,
    required this.newPassword,
    required this.confirmPassword,
  });

  @override
  List<Object?> get props => [currentPassword, newPassword, confirmPassword];
}

class ManageAddresses extends ProfileEvent {
  const ManageAddresses();
}

class AddAddress extends ProfileEvent {
  final Map<String, dynamic> address;

  const AddAddress({required this.address});

  @override
  List<Object?> get props => [address];
}

class UpdateAddress extends ProfileEvent {
  final String addressId;
  final Map<String, dynamic> updatedAddress;

  const UpdateAddress({
    required this.addressId,
    required this.updatedAddress,
  });

  @override
  List<Object?> get props => [addressId, updatedAddress];
}

class DeleteAddress extends ProfileEvent {
  final String addressId;

  const DeleteAddress({required this.addressId});

  @override
  List<Object?> get props => [addressId];
}

class SetDefaultAddress extends ProfileEvent {
  final String addressId;

  const SetDefaultAddress({required this.addressId});

  @override
  List<Object?> get props => [addressId];
}

class ChangeLanguage extends ProfileEvent {
  final String languageCode;

  const ChangeLanguage({required this.languageCode});

  @override
  List<Object?> get props => [languageCode];
}

class LogoutUser extends ProfileEvent {
  const LogoutUser();
}

class UpdateNotificationPreferences extends ProfileEvent {
  final Map<String, dynamic> preferences;

  const UpdateNotificationPreferences({required this.preferences});

  @override
  List<Object?> get props => [preferences];
}

class UpdateProfilePicture extends ProfileEvent {
  final String imageFile;

  const UpdateProfilePicture({required this.imageFile});

  @override
  List<Object?> get props => [imageFile];
}