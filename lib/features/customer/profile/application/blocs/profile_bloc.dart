import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:khubzati/features/customer/profile/data/services/profile_service.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileService profileService;

  ProfileBloc({
    required this.profileService,
  }) : super(ProfileInitial()) {
    on<LoadUserProfile>(_onLoadUserProfile);
    on<UpdateUserProfile>(_onUpdateUserProfile);
    on<ChangePassword>(_onChangePassword);
    on<ManageAddresses>(_onManageAddresses);
    on<AddAddress>(_onAddAddress);
    on<UpdateAddress>(_onUpdateAddress);
    on<DeleteAddress>(_onDeleteAddress);
    on<SetDefaultAddress>(_onSetDefaultAddress);
    on<ChangeLanguage>(_onChangeLanguage);
    on<LogoutUser>(_onLogoutUser);
    on<UpdateNotificationPreferences>(_onUpdateNotificationPreferences);
    on<UpdateProfilePicture>(_onUpdateProfilePicture);
  }

  Future<void> _onLoadUserProfile(
      LoadUserProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      // Get user profile from API
      final user = await profileService.getUserProfile();

      // Get user addresses from API (in a real app, this might be a separate service)
      final addresses = await profileService.getUserProfile();

      // Get saved payment methods
      final paymentMethods = await profileService.getSavedPaymentMethods();

      // Get current language (in a real app, this might come from a localization service)
      // For now, we'll assume it's stored in the user profile
      final currentLanguage = user['language_preference'] ??
          'ar'; // Default to Arabic as per requirements

      emit(ProfileLoaded(
        user: user,
        addresses: addresses,
        paymentMethods: paymentMethods,
        currentLanguage: currentLanguage,
      ));
    } catch (e) {
      emit(ProfileError('Failed to load profile: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateUserProfile(
      UpdateUserProfile event, Emitter<ProfileState> emit) async {
    if (state is ProfileLoaded) {
      final currentState = state as ProfileLoaded;
      emit(ProfileUpdateInProgress());

      try {
        // Prepare profile data for update
        final profileData = {
          'name': event.name ?? currentState.user['name'],
          'email': event.email ?? currentState.user['email'],
          'phone': event.phone ?? currentState.user['phone'],
        };

        // Call API to update profile
        final updatedUser = await profileService.updateProfile(profileData);

        emit(const ProfileUpdateSuccess('Profile updated successfully'));

        // Reload profile to show updated data
        emit(ProfileLoaded(
          user: updatedUser,
          addresses: currentState.addresses,
          paymentMethods: currentState.paymentMethods,
          currentLanguage: currentState.currentLanguage,
        ));
      } catch (e) {
        emit(ProfileError('Failed to update profile: ${e.toString()}'));
      }
    }
  }

  Future<void> _onUpdateProfilePicture(
      UpdateProfilePicture event, Emitter<ProfileState> emit) async {
    if (state is ProfileLoaded) {
      final currentState = state as ProfileLoaded;
      emit(ProfileUpdateInProgress());

      try {
        // Call API to update profile picture
        final updatedUser =
            await profileService.updateProfilePicture(event.imageFile);

        emit(
            const ProfileUpdateSuccess('Profile picture updated successfully'));

        // Reload profile to show updated data
        emit(ProfileLoaded(
          user: updatedUser,
          addresses: currentState.addresses,
          paymentMethods: currentState.paymentMethods,
          currentLanguage: currentState.currentLanguage,
        ));
      } catch (e) {
        emit(ProfileError('Failed to update profile picture: ${e.toString()}'));
      }
    }
  }

  Future<void> _onChangePassword(
      ChangePassword event, Emitter<ProfileState> emit) async {
    emit(PasswordChangeInProgress());
    try {
      // Call API to change password
      final success = await profileService.changePassword(
        currentPassword: event.currentPassword,
        newPassword: event.newPassword,
        confirmPassword: event.confirmPassword,
      );

      if (success) {
        emit(const PasswordChangeSuccess('Password changed successfully'));

        // Return to loaded state if we were there before
        if (state is ProfileLoaded) {
          final currentState = state as ProfileLoaded;
          emit(ProfileLoaded(
            user: currentState.user,
            addresses: currentState.addresses,
            paymentMethods: currentState.paymentMethods,
            currentLanguage: currentState.currentLanguage,
          ));
        }
      } else {
        emit(const ProfileError('Failed to change password'));
      }
    } catch (e) {
      emit(ProfileError('Failed to change password: ${e.toString()}'));
    }
  }

  Future<void> _onManageAddresses(
      ManageAddresses event, Emitter<ProfileState> emit) async {
    if (state is ProfileLoaded) {
      final currentState = state as ProfileLoaded;
      emit(AddressManagementState(currentState.addresses));
    } else {
      // If we're not in loaded state, load the profile first
      add(LoadUserProfile());
    }
  }

  Future<void> _onAddAddress(
      AddAddress event, Emitter<ProfileState> emit) async {
    emit(AddressOperationInProgress());
    try {
      // Call API to add address
      final newAddress = await profileService.addDeliveryAddress(event.address);

      if (state is ProfileLoaded) {
        final currentState = state as ProfileLoaded;
        final addresses =
            List<Map<String, dynamic>>.from(currentState.addresses);

        // Add the new address to the list
        addresses.add(newAddress);

        emit(const AddressOperationSuccess(
          message: 'Address added successfully',
          operationType: 'add',
        ));

        // Update profile state with new addresses
        emit(ProfileLoaded(
          user: currentState.user,
          addresses: addresses,
          paymentMethods: currentState.paymentMethods,
          currentLanguage: currentState.currentLanguage,
        ));
      }
    } catch (e) {
      emit(ProfileError('Failed to add address: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateAddress(
      UpdateAddress event, Emitter<ProfileState> emit) async {
    emit(AddressOperationInProgress());
    try {
      // Call API to update address
      final updatedAddress = await profileService.updateDeliveryAddress(
        event.addressId,
        event.updatedAddress,
      );

      if (state is ProfileLoaded) {
        final currentState = state as ProfileLoaded;
        final addresses =
            List<Map<String, dynamic>>.from(currentState.addresses);

        // Find and update the address
        final index =
            addresses.indexWhere((addr) => addr['id'] == event.addressId);
        if (index != -1) {
          addresses[index] = updatedAddress;

          emit(const AddressOperationSuccess(
            message: 'Address updated successfully',
            operationType: 'update',
          ));

          // Update profile state with updated addresses
          emit(ProfileLoaded(
            user: currentState.user,
            addresses: addresses,
            paymentMethods: currentState.paymentMethods,
            currentLanguage: currentState.currentLanguage,
          ));
        } else {
          emit(const ProfileError('Address not found'));
        }
      }
    } catch (e) {
      emit(ProfileError('Failed to update address: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteAddress(
      DeleteAddress event, Emitter<ProfileState> emit) async {
    emit(AddressOperationInProgress());
    try {
      // Call API to delete address
      final success =
          await profileService.deleteDeliveryAddress(event.addressId);

      if (success && state is ProfileLoaded) {
        final currentState = state as ProfileLoaded;
        final addresses =
            List<Map<String, dynamic>>.from(currentState.addresses);

        // Remove the address from the list
        addresses.removeWhere((addr) => addr['id'] == event.addressId);

        emit(const AddressOperationSuccess(
          message: 'Address deleted successfully',
          operationType: 'delete',
        ));

        // Update profile state with updated addresses
        emit(ProfileLoaded(
          user: currentState.user,
          addresses: addresses,
          paymentMethods: currentState.paymentMethods,
          currentLanguage: currentState.currentLanguage,
        ));
      }
    } catch (e) {
      emit(ProfileError('Failed to delete address: ${e.toString()}'));
    }
  }

  Future<void> _onSetDefaultAddress(
      SetDefaultAddress event, Emitter<ProfileState> emit) async {
    emit(AddressOperationInProgress());
    try {
      // In a real app, this would be a separate API call
      // For now, we'll update the address with is_default=true
      if (state is ProfileLoaded) {
        final currentState = state as ProfileLoaded;
        final addresses =
            List<Map<String, dynamic>>.from(currentState.addresses);

        // Update default status for all addresses
        for (int i = 0; i < addresses.length; i++) {
          if (addresses[i]['id'] == event.addressId) {
            // Call API to update this address as default
            final updatedAddress = await profileService.updateDeliveryAddress(
              event.addressId,
              {...addresses[i], 'is_default': true},
            );
            addresses[i] = updatedAddress;
          } else if (addresses[i]['is_default'] == true) {
            // Call API to update previous default address
            final updatedAddress = await profileService.updateDeliveryAddress(
              addresses[i]['id'],
              {...addresses[i], 'is_default': false},
            );
            addresses[i] = updatedAddress;
          }
        }

        emit(const AddressOperationSuccess(
          message: 'Default address updated',
          operationType: 'set_default',
        ));

        // Update profile state with updated addresses
        emit(ProfileLoaded(
          user: currentState.user,
          addresses: addresses,
          paymentMethods: currentState.paymentMethods,
          currentLanguage: currentState.currentLanguage,
        ));
      }
    } catch (e) {
      emit(ProfileError('Failed to set default address: ${e.toString()}'));
    }
  }

  Future<void> _onChangeLanguage(
      ChangeLanguage event, Emitter<ProfileState> emit) async {
    emit(LanguageChangeInProgress());
    try {
      // Call API to update language preference
      final success =
          await profileService.updateLanguagePreference(event.languageCode);

      if (success) {
        emit(LanguageChangeSuccess(event.languageCode));

        // Update profile state with new language
        if (state is ProfileLoaded) {
          final currentState = state as ProfileLoaded;
          emit(ProfileLoaded(
            user: {
              ...currentState.user,
              'language_preference': event.languageCode
            },
            addresses: currentState.addresses,
            paymentMethods: currentState.paymentMethods,
            currentLanguage: event.languageCode,
          ));
        }
      } else {
        emit(const ProfileError('Failed to change language'));
      }
    } catch (e) {
      emit(ProfileError('Failed to change language: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateNotificationPreferences(
      UpdateNotificationPreferences event, Emitter<ProfileState> emit) async {
    emit(NotificationPreferencesUpdateInProgress());
    try {
      // Call API to update notification preferences
      final updatedPreferences =
          await profileService.updateNotificationPreferences(event.preferences);

      emit(const NotificationPreferencesUpdateSuccess(
          'Notification preferences updated successfully'));

      // Update profile state with new preferences
      if (state is ProfileLoaded) {
        final currentState = state as ProfileLoaded;
        final updatedUser = {
          ...currentState.user,
          'notification_preferences': updatedPreferences
        };

        emit(ProfileLoaded(
          user: updatedUser,
          addresses: currentState.addresses,
          paymentMethods: currentState.paymentMethods,
          currentLanguage: currentState.currentLanguage,
        ));
      }
    } catch (e) {
      emit(ProfileError(
          'Failed to update notification preferences: ${e.toString()}'));
    }
  }

  Future<void> _onLogoutUser(
      LogoutUser event, Emitter<ProfileState> emit) async {
    emit(LogoutInProgress());
    try {
      // In a real app, this would call the auth service to logout
      // For now, we'll just emit the initial state

      // After logout, we would typically navigate to login screen
      // This would be handled by the UI layer listening to this state
      emit(LogoutSuccess());
    } catch (e) {
      emit(ProfileError('Failed to logout: ${e.toString()}'));
    }
  }
}
