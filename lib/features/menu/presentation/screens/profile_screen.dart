// ignore_for_file: use_build_context_synchronously

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'dart:io';
import 'package:khubzati/core/theme/styles/app_colors.dart';
import 'package:khubzati/core/theme/styles/app_text_style.dart';
import 'package:khubzati/features/menu/application/blocs/profile/profile_bloc.dart';
import 'package:khubzati/features/menu/application/blocs/profile/profile_event.dart';
import 'package:khubzati/features/menu/application/blocs/profile/profile_state.dart';
import 'package:khubzati/features/menu/presentation/widgets/profile_picture.dart';
import 'package:khubzati/features/menu/presentation/widgets/profile_form.dart';
import 'package:khubzati/features/menu/presentation/widgets/profile_action_buttons.dart';
import 'package:khubzati/features/menu/presentation/widgets/logout_confirmation_dialog.dart';
import 'package:khubzati/core/widgets/shared/app_loading_widget.dart';
import 'package:khubzati/features/auth/application/blocs/auth_bloc.dart';
import 'package:khubzati/core/routes/app_router.dart';
import 'package:khubzati/gen/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

@RoutePage()
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _bakeryNameController;
  late TextEditingController _addressController;
  late PhoneController _phoneNumberController;
  final ImagePicker _imagePicker = ImagePicker();
  File? _selectedImage;
  bool _hasUpdated = false;

  @override
  void initState() {
    super.initState();
    _bakeryNameController = TextEditingController();
    _addressController = TextEditingController();
    _phoneNumberController = PhoneController();

    // Load profile data when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<ProfileBloc>().add(const LoadProfile());
      }
    });
  }

  @override
  void dispose() {
    _bakeryNameController.dispose();
    _addressController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    // Store context before async operation
    final currentContext = context;

    try {
      // Show loading indicator
      showDialog(
        context: currentContext,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 400,
        maxHeight: 400,
        imageQuality: 85,
      );

      // Hide loading indicator
      if (mounted) {
        Navigator.of(currentContext).pop();
      }

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });

        // Update profile image in BLoC
        if (mounted) {
          currentContext.read<ProfileBloc>().add(
                UpdateProfileImage(image.path),
              );
        }
      }
    } catch (e) {
      // Hide loading indicator if still showing
      if (mounted) {
        Navigator.of(currentContext).pop();
      }

      if (mounted) {
        ScaffoldMessenger.of(currentContext).showSnackBar(
          SnackBar(
            content: Text('Failed to pick image: ${e.toString()}'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.fixed,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Unauthenticated) {
          // Navigate to login screen after successful logout
          context.router.replaceAll([const LoginRoute()]);
        } else if (state is AuthError) {
          // Show error message if logout fails
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.fixed,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      },
      child: PopScope(
        canPop: false,
        onPopInvoked: (didPop) async {
          if (!didPop) {
            final shouldPop = await _onWillPop();
            if (shouldPop && mounted) {
              context.router.popForced();
            }
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.creamColor,
          appBar: AppBar(
            backgroundColor: AppColors.creamColor,
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: AppColors.primaryBurntOrange,
                size: 20.sp,
              ),
              onPressed: () async {
                final shouldPop = await _onWillPop();
                if (shouldPop && mounted) {
                  context.router.popForced();
                }
              },
            ),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.logout,
                  color: AppColors.primaryBurntOrange,
                  size: 24.sp,
                ),
                onPressed: _showLogoutDialog,
              ),
            ],
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // const ProfileHeader(),
              20.verticalSpace,
              Expanded(
                child: BlocConsumer<ProfileBloc, ProfileState>(
                  listener: (context, state) {
                    if (state is ProfileLoaded &&
                        !state.isEditing &&
                        _hasUpdated) {
                      // Show success message when profile is updated
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                              Text(LocaleKeys.app_profile_profile_updated.tr()),
                          backgroundColor: AppColors.success,
                          behavior: SnackBarBehavior.fixed,
                          duration: const Duration(seconds: 3),
                        ),
                      );
                      _hasUpdated = false; // Reset flag
                    }
                  },
                  builder: (context, state) {
                    if (state is ProfileInitial) {
                      // Trigger load profile when in initial state
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted) {
                          context.read<ProfileBloc>().add(const LoadProfile());
                        }
                      });
                      return const Center(
                        child: AppLoadingWidget(),
                      );
                    } else if (state is ProfileLoading) {
                      return const Center(
                        child: AppLoadingWidget(),
                      );
                    } else if (state is ProfileError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              state.message,
                              style: AppTextStyles.font14TextW400OP8,
                              textAlign: TextAlign.center,
                            ),
                            16.verticalSpace,
                            ElevatedButton(
                              onPressed: () {
                                context
                                    .read<ProfileBloc>()
                                    .add(const LoadProfile());
                              },
                              child: Text(LocaleKeys.app_common_retry.tr()),
                            ),
                          ],
                        ),
                      );
                    } else if (state is ProfileLoaded) {
                      // Populate controllers with profile data
                      _bakeryNameController.text = state.profileData.bakeryName;
                      _addressController.text = state.profileData.address;
                      // Parse phone number and set it in PhoneController
                      if (state.profileData.phoneNumber.isNotEmpty) {
                        try {
                          _phoneNumberController.value =
                              PhoneNumber.parse(state.profileData.phoneNumber);
                        } catch (e) {
                          // If parsing fails, create a new PhoneNumber with default country
                          _phoneNumberController.value = PhoneNumber(
                            isoCode: IsoCode.JO,
                            nsn: state.profileData.phoneNumber,
                          );
                        }
                      }

                      return SingleChildScrollView(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Column(
                          children: [
                            40.verticalSpace,
                            // Profile Picture
                            Center(
                              child: ProfilePicture(
                                imageUrl: _selectedImage != null
                                    ? _selectedImage!.path
                                    : state.profileData.profileImageUrl,
                                isEditing: state.isEditing,
                                onTap: state.isEditing ? _pickImage : null,
                              ),
                            ),
                            40.verticalSpace,
                            // Profile Form
                            ProfileForm(
                              bakeryNameController: _bakeryNameController,
                              addressController: _addressController,
                              phoneNumberController: _phoneNumberController,
                              isEditing: state.isEditing,
                              onBakeryNameChanged: (value) {
                                // Controller is already updated automatically
                              },
                              onAddressChanged: (value) {
                                // Controller is already updated automatically
                              },
                              onPhoneNumberChanged: (phoneNumber) {
                                // Controller is already updated automatically
                              },
                            ),
                            40.verticalSpace,

                            // Action Buttons
                            ProfileActionButtons(
                              isEditing: state.isEditing,
                              onEditPressed: () {
                                context
                                    .read<ProfileBloc>()
                                    .add(const ToggleEditMode());
                              },
                              onSavePressed: () {
                                _hasUpdated = true; // Set flag before update
                                context.read<ProfileBloc>().add(
                                      UpdateProfile(
                                        bakeryName: _bakeryNameController.text,
                                        address: _addressController.text,
                                        phoneNumber: _phoneNumberController
                                            .value.international,
                                        profileImageUrl: _selectedImage?.path,
                                      ),
                                    );
                              },
                              onCancelPressed: () {
                                context
                                    .read<ProfileBloc>()
                                    .add(const CancelEdit());
                              },
                            ),
                          ],
                        ),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    // Check if we're in editing mode
    final profileBloc = context.read<ProfileBloc>();
    final state = profileBloc.state;

    if (state is ProfileLoaded && state.isEditing) {
      // Show confirmation dialog for unsaved changes
      return await _showUnsavedChangesDialog();
    }

    return true; // Allow back navigation
  }

  Future<bool> _showUnsavedChangesDialog() async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                'Unsaved Changes',
                style: AppTextStyles.font16textDarkBrownBold,
              ),
              content: Text(
                'You have unsaved changes. Are you sure you want to discard them?',
                style: AppTextStyles.font14TextW400OP8,
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false); // Don't go back
                  },
                  child: Text(
                    LocaleKeys.app_common_cancel.tr(),
                    style: AppTextStyles.font14TextW400OP8.copyWith(
                      color: AppColors.textDarkBrown,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Cancel editing and go back
                    context.read<ProfileBloc>().add(const CancelEdit());
                    Navigator.of(context).pop(true); // Go back
                  },
                  child: Text(
                    'Discard',
                    style: AppTextStyles.font14TextW400OP8.copyWith(
                      color: AppColors.error,
                    ),
                  ),
                ),
              ],
            );
          },
        ) ??
        false; // Default to not going back if dialog is dismissed
  }

  void _showLogoutDialog() {
    LogoutConfirmationDialog.show(
      context: context,
      onConfirm: _performLogout,
    );
  }

  void _performLogout() {
    // Dispatch logout event to AuthBloc
    context.read<AuthBloc>().add(LogoutRequested());
  }
}
