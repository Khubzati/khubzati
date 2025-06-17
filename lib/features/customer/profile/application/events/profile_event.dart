part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadUserProfile extends ProfileEvent {}

class UpdateUserProfile extends ProfileEvent {
  final String? name;
  final String? email;
  final String? phone;
  final String? profileImage;

  const UpdateUserProfile({
    this.name,
    this.email,
    this.phone,
    this.profileImage,
  });

  @override
  List<Object?> get props => [name, email, phone, profileImage];
}

class ChangePassword extends ProfileEvent {
  final String currentPassword;
  final String newPassword;

  const ChangePassword({
    required this.currentPassword,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [currentPassword, newPassword];
}

class ManageAddresses extends ProfileEvent {}

class AddAddress extends ProfileEvent {
  final Map<String, dynamic> address;

  const AddAddress(this.address);

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

  const DeleteAddress(this.addressId);

  @override
  List<Object?> get props => [addressId];
}

class SetDefaultAddress extends ProfileEvent {
  final String addressId;

  const SetDefaultAddress(this.addressId);

  @override
  List<Object?> get props => [addressId];
}

class ChangeLanguage extends ProfileEvent {
  final String languageCode;

  const ChangeLanguage(this.languageCode);

  @override
  List<Object?> get props => [languageCode];
}

class LogoutUser extends ProfileEvent {}
