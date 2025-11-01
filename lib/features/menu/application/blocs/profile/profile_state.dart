import 'package:equatable/equatable.dart';
import 'package:khubzati/features/menu/domain/models/profile_data.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

class ProfileLoaded extends ProfileState {
  final ProfileData profileData;
  final bool isEditing;

  const ProfileLoaded({
    required this.profileData,
    this.isEditing = false,
  });

  ProfileLoaded copyWith({
    ProfileData? profileData,
    bool? isEditing,
  }) {
    return ProfileLoaded(
      profileData: profileData ?? this.profileData,
      isEditing: isEditing ?? this.isEditing,
    );
  }

  @override
  List<Object?> get props => [profileData, isEditing];
}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError(this.message);

  @override
  List<Object?> get props => [message];
}

class ProfileUpdated extends ProfileState {
  final ProfileData profileData;

  const ProfileUpdated(this.profileData);

  @override
  List<Object?> get props => [profileData];
}
