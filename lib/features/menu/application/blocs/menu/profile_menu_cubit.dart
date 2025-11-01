import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:khubzati/features/menu/data/services/profile_service.dart';
import 'package:khubzati/features/menu/domain/models/profile_data.dart';

part 'profile_menu_state.dart';

@injectable
class ProfileMenuCubit extends Cubit<ProfileMenuState> {
  final ProfileService profileService;

  ProfileMenuCubit({required this.profileService})
      : super(ProfileMenuInitial());

  /// Load profile data for display in menu
  Future<void> loadProfile() async {
    emit(ProfileMenuLoading());
    try {
      final profileData = await profileService.getProfile();
      emit(ProfileMenuLoaded(profileData: profileData));
    } catch (e) {
      emit(ProfileMenuError(message: e.toString()));
    }
  }
}
