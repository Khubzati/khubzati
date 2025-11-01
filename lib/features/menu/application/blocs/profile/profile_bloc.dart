import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'profile_event.dart';
import 'profile_state.dart';
import 'package:khubzati/features/menu/data/services/profile_service.dart';

@injectable
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileService _profileService;

  ProfileBloc({required ProfileService profileService})
      : _profileService = profileService,
        super(const ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateProfile>(_onUpdateProfile);
    on<ToggleEditMode>(_onToggleEditMode);
    on<CancelEdit>(_onCancelEdit);
    on<UpdateProfileImage>(_onUpdateProfileImage);
  }

  Future<void> _onLoadProfile(
    LoadProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileLoading());
    try {
      final profileData = await _profileService.getProfile();
      emit(ProfileLoaded(profileData: profileData));
    } catch (e) {
      emit(ProfileError('Failed to load profile: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateProfile(
    UpdateProfile event,
    Emitter<ProfileState> emit,
  ) async {
    if (state is ProfileLoaded) {
      emit(const ProfileLoading());

      try {
        final updatedProfile = await _profileService.updateProfile(
          bakeryName: event.bakeryName,
          address: event.address,
          phoneNumber: event.phoneNumber,
          profileImageUrl: event.profileImageUrl,
        );
        emit(ProfileLoaded(profileData: updatedProfile, isEditing: false));
      } catch (e) {
        emit(ProfileError('Failed to update profile: ${e.toString()}'));
      }
    }
  }

  void _onToggleEditMode(
    ToggleEditMode event,
    Emitter<ProfileState> emit,
  ) {
    if (state is ProfileLoaded) {
      final currentState = state as ProfileLoaded;
      emit(currentState.copyWith(isEditing: !currentState.isEditing));
    }
  }

  void _onCancelEdit(
    CancelEdit event,
    Emitter<ProfileState> emit,
  ) {
    if (state is ProfileLoaded) {
      final currentState = state as ProfileLoaded;
      emit(currentState.copyWith(isEditing: false));
    }
  }

  Future<void> _onUpdateProfileImage(
    UpdateProfileImage event,
    Emitter<ProfileState> emit,
  ) async {
    if (state is ProfileLoaded) {
      final currentState = state as ProfileLoaded;
      try {
        final imageUrl =
            await _profileService.uploadProfileImage(event.imageUrl);
        final updatedProfile = currentState.profileData.copyWith(
          profileImageUrl: imageUrl,
          lastUpdated: DateTime.now(),
        );
        emit(ProfileLoaded(
          profileData: updatedProfile,
          isEditing: currentState.isEditing,
        ));
      } catch (e) {
        emit(ProfileError('Failed to update profile image: ${e.toString()}'));
      }
    }
  }
}
