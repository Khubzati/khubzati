part of 'profile_menu_cubit.dart';

abstract class ProfileMenuState extends Equatable {
  const ProfileMenuState();

  @override
  List<Object?> get props => [];
}

class ProfileMenuInitial extends ProfileMenuState {}

class ProfileMenuLoading extends ProfileMenuState {}

class ProfileMenuLoaded extends ProfileMenuState {
  final ProfileData profileData;

  const ProfileMenuLoaded({required this.profileData});

  @override
  List<Object?> get props => [profileData];
}

class ProfileMenuError extends ProfileMenuState {
  final String message;

  const ProfileMenuError({required this.message});

  @override
  List<Object?> get props => [message];
}
