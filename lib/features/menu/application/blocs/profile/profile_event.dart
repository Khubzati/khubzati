import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadProfile extends ProfileEvent {
  const LoadProfile();
}

class UpdateProfile extends ProfileEvent {
  final String bakeryName;
  final String address;
  final String phoneNumber;
  final String? profileImageUrl;

  const UpdateProfile({
    required this.bakeryName,
    required this.address,
    required this.phoneNumber,
    this.profileImageUrl,
  });

  @override
  List<Object?> get props => [bakeryName, address, phoneNumber, profileImageUrl];
}

class ToggleEditMode extends ProfileEvent {
  const ToggleEditMode();
}

class CancelEdit extends ProfileEvent {
  const CancelEdit();
}

class UpdateProfileImage extends ProfileEvent {
  final String imageUrl;

  const UpdateProfileImage(this.imageUrl);

  @override
  List<Object?> get props => [imageUrl];
}
