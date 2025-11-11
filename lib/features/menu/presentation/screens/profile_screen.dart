// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phone_form_field/phone_form_field.dart';

import 'package:khubzati/core/routes/app_router.dart';
import 'package:khubzati/core/theme/styles/app_colors.dart';
import 'package:khubzati/core/theme/styles/app_text_style.dart';
import 'package:khubzati/core/widgets/shared/app_loading_widget.dart';
import 'package:khubzati/features/auth/application/blocs/auth_bloc.dart';
import 'package:khubzati/features/menu/application/blocs/profile/profile_bloc.dart';
import 'package:khubzati/features/menu/application/blocs/profile/profile_event.dart';
import 'package:khubzati/features/menu/application/blocs/profile/profile_state.dart';
import 'package:khubzati/features/menu/presentation/widgets/logout_confirmation_dialog.dart';
import 'package:khubzati/features/menu/presentation/widgets/profile_action_buttons.dart';
import 'package:khubzati/features/menu/presentation/widgets/profile_form.dart';
import 'package:khubzati/features/menu/presentation/widgets/profile_picture.dart';
import 'package:khubzati/gen/translations/locale_keys.g.dart';

/// Profile Screen - Clean Architecture Implementation
/// 
/// Features:
/// - BLoC pattern for state management
/// - Responsive design using ScreenUtil
/// - Full localization support
/// - Reusable widgets
/// - Proper error handling
@RoutePage()
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Controllers
  late final TextEditingController _bakeryNameController;
  late final TextEditingController _addressController;
  late final PhoneController _phoneNumberController;
  
  // Image picker
  final ImagePicker _imagePicker = ImagePicker();
  File? _selectedImage;
  
  // State flags
  bool _hasUnsavedChanges = false;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _loadProfileData();
  }

  void _initializeControllers() {
    _bakeryNameController = TextEditingController();
    _addressController = TextEditingController();
    _phoneNumberController = PhoneController();

    // Listen to controller changes to track unsaved changes
    _bakeryNameController.addListener(_onFormChanged);
    _addressController.addListener(_onFormChanged);
    _phoneNumberController.addListener(_onFormChanged);
  }

  void _onFormChanged() {
    if (_isInitialized) {
      setState(() {
        _hasUnsavedChanges = true;
      });
    }
  }

  void _loadProfileData() {
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

  /// Picks an image from the gallery and updates the profile image
  Future<void> _pickImage() async {
    final currentContext = context;

    try {
      // Show loading indicator
      if (mounted) {
      showDialog(
        context: currentContext,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );
      }

      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      // Hide loading indicator
      if (mounted) {
        Navigator.of(currentContext).pop();
      }

      if (image != null && mounted) {
        setState(() {
          _selectedImage = File(image.path);
          _hasUnsavedChanges = true;
        });

        // Update profile image in BLoC
          currentContext.read<ProfileBloc>().add(
                UpdateProfileImage(image.path),
              );
      }
    } catch (e) {
      // Hide loading indicator if still showing
      if (mounted) {
        Navigator.of(currentContext).pop();
      }

      if (mounted) {
        ScaffoldMessenger.of(currentContext).showSnackBar(
          SnackBar(
            content: Text(
              'app.profile.failed_to_pick_image'.tr(),
              style: AppTextStyles.font14TextW400OP8.copyWith(
                color: Colors.white,
              ),
            ),
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
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Unauthenticated) {
          context.router.replaceAll([const LoginRoute()]);
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                  content: Text(
                    state.message,
                    style: AppTextStyles.font14TextW400OP8.copyWith(
                      color: Colors.white,
                    ),
                  ),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.fixed,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      },
        ),
        BlocListener<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state is ProfileLoaded && !state.isEditing && _hasUnsavedChanges) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    LocaleKeys.app_profile_profile_updated.tr(),
                    style: AppTextStyles.font14TextW400OP8.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  backgroundColor: AppColors.success,
                  behavior: SnackBarBehavior.fixed,
                  duration: const Duration(seconds: 3),
                ),
              );
              setState(() {
                _hasUnsavedChanges = false;
              });
            }
          },
        ),
      ],
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
          appBar: _buildAppBar(context),
          body: SafeArea(
            child: _buildBody(context),
          ),
        ),
      ),
    );
  }

  /// Builds the app bar with responsive design
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
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
          tooltip: LocaleKeys.app_general_logout.tr(),
        ),
      ],
    );
  }

  /// Builds the main body content with responsive layout
  Widget _buildBody(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
                  builder: (context, state) {
                    if (state is ProfileInitial) {
          _loadProfileData();
          return const Center(child: AppLoadingWidget());
        }

        if (state is ProfileLoading) {
          return const Center(child: AppLoadingWidget());
        }

        if (state is ProfileError) {
          return _buildErrorState(context, state.message);
        }

        if (state is ProfileLoaded) {
          _populateControllers(state);
          return _buildProfileContent(context, state);
        }

        return const SizedBox.shrink();
      },
                      );
  }

  /// Populates form controllers with profile data
  void _populateControllers(ProfileLoaded state) {
    if (!_isInitialized) {
                      _bakeryNameController.text = state.profileData.bakeryName;
                      _addressController.text = state.profileData.address;
      
                      if (state.profileData.phoneNumber.isNotEmpty) {
                        try {
                          _phoneNumberController.value =
                              PhoneNumber.parse(state.profileData.phoneNumber);
                        } catch (e) {
                          _phoneNumberController.value = PhoneNumber(
                            isoCode: IsoCode.JO,
                            nsn: state.profileData.phoneNumber,
                          );
                        }
                      }
      
      _isInitialized = true;
      _hasUnsavedChanges = false;
    }
  }

  /// Builds the error state widget
  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64.sp,
              color: AppColors.error,
            ),
            16.verticalSpace,
            Text(
              message,
              style: AppTextStyles.font14TextW400OP8,
              textAlign: TextAlign.center,
            ),
            24.verticalSpace,
            ElevatedButton(
              onPressed: () {
                context.read<ProfileBloc>().add(const LoadProfile());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBurntOrange,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: 32.w,
                  vertical: 12.h,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text(
                LocaleKeys.app_common_retry.tr(),
                style: AppTextStyles.font14TextW400OP8.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the profile content with responsive layout
  Widget _buildProfileContent(BuildContext context, ProfileLoaded state) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Responsive padding based on screen width
        final horizontalPadding = constraints.maxWidth > 600 ? 40.w : 20.w;
        final verticalSpacing = constraints.maxWidth > 600 ? 60.h : 40.h;

                      return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
                        child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                verticalSpacing.verticalSpace,
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
                verticalSpacing.verticalSpace,
                            // Profile Form
                            ProfileForm(
                              bakeryNameController: _bakeryNameController,
                              addressController: _addressController,
                              phoneNumberController: _phoneNumberController,
                              isEditing: state.isEditing,
                  onBakeryNameChanged: (_) {},
                  onAddressChanged: (_) {},
                  onPhoneNumberChanged: (_) {},
                            ),
                verticalSpacing.verticalSpace,
                            // Action Buttons
                            ProfileActionButtons(
                              isEditing: state.isEditing,
                              onEditPressed: () {
                    context.read<ProfileBloc>().add(const ToggleEditMode());
                              },
                  onSavePressed: _handleSave,
                  onCancelPressed: _handleCancel,
                ),
                // Bottom spacing for better UX
                (verticalSpacing * 0.5).verticalSpace,
            ],
          ),
        ),
        );
      },
    );
  }

  /// Handles save action
  void _handleSave() {
    setState(() {
      _hasUnsavedChanges = true;
    });
    
    context.read<ProfileBloc>().add(
          UpdateProfile(
            bakeryName: _bakeryNameController.text.trim(),
            address: _addressController.text.trim(),
            phoneNumber: _phoneNumberController.value.international,
            profileImageUrl: _selectedImage?.path,
      ),
    );
  }

  /// Handles cancel action
  void _handleCancel() {
    context.read<ProfileBloc>().add(const CancelEdit());
    setState(() {
      _hasUnsavedChanges = false;
      _selectedImage = null;
      _isInitialized = false;
    });
    // Reload to reset form
    context.read<ProfileBloc>().add(const LoadProfile());
  }

  /// Handles back navigation with unsaved changes check
  Future<bool> _onWillPop() async {
    final profileBloc = context.read<ProfileBloc>();
    final state = profileBloc.state;

    if (state is ProfileLoaded && (state.isEditing || _hasUnsavedChanges)) {
      return await _showUnsavedChangesDialog();
    }

    return true;
  }

  /// Shows dialog for unsaved changes confirmation
  Future<bool> _showUnsavedChangesDialog() async {
    return await showDialog<bool>(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              backgroundColor: AppColors.creamColor,
              title: Text(
                'app.profile.unsaved_changes_title'.tr(),
                style: AppTextStyles.font20textDarkBrownbold,
                textAlign: TextAlign.center,
              ),
              content: Text(
                'app.profile.unsaved_changes_message'.tr(),
                style: AppTextStyles.font14TextW400OP8,
                textAlign: TextAlign.center,
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 12.h,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      side: BorderSide(
                        color: AppColors.textDarkBrown.withOpacity(0.3),
                        width: 1.w,
                      ),
                    ),
                  ),
                  child: Text(
                    LocaleKeys.app_common_cancel.tr(),
                    style: AppTextStyles.font14TextW400OP8.copyWith(
                      color: AppColors.textDarkBrown,
                    ),
                  ),
                ),
                8.horizontalSpace,
                TextButton(
                  onPressed: () {
                    context.read<ProfileBloc>().add(const CancelEdit());
                    Navigator.of(context).pop(true);
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 12.h,
                    ),
                    backgroundColor: AppColors.error.withOpacity(0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: Text(
                    'app.profile.discard'.tr(),
                    style: AppTextStyles.font14TextW400OP8.copyWith(
                      color: AppColors.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
              actionsAlignment: MainAxisAlignment.center,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 24.w,
                vertical: 20.h,
              ),
              titlePadding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 12.h),
            );
          },
        ) ??
        false;
  }

  /// Shows logout confirmation dialog
  void _showLogoutDialog() {
    LogoutConfirmationDialog.show(
      context: context,
      onConfirm: _performLogout,
    );
  }

  /// Performs logout action
  void _performLogout() {
    context.read<AuthBloc>().add(LogoutRequested());
  }
}
