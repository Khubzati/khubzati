// ignore_for_file: deprecated_member_use

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:khubzati/core/theme/styles/app_colors.dart';
import 'package:khubzati/core/theme/styles/app_text_style.dart';
import 'package:khubzati/core/widgets/shared/app_loading_widget.dart';
import 'package:khubzati/features/menu/application/blocs/menu/profile_menu_cubit.dart';
import 'package:khubzati/features/menu/presentation/widgets/profile_menu_header.dart';
import 'package:khubzati/features/menu/presentation/widgets/profile_menu_item.dart';
import 'package:khubzati/features/menu/presentation/widgets/logout_confirmation_dialog.dart';
import 'package:khubzati/features/auth/application/blocs/auth_bloc.dart';
import 'package:khubzati/core/routes/app_router.dart';
import 'package:khubzati/gen/translations/locale_keys.g.dart';

@RoutePage()
class ProfileMenuScreen extends StatefulWidget {
  const ProfileMenuScreen({super.key});

  @override
  State<ProfileMenuScreen> createState() => _ProfileMenuScreenState();
}

class _ProfileMenuScreenState extends State<ProfileMenuScreen> {
  @override
  void initState() {
    super.initState();
    // Load profile data when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<ProfileMenuCubit>().loadProfile();
      }
    });
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
      child: Scaffold(
        backgroundColor: AppColors.pageBackground,
        body: SafeArea(
          child: BlocBuilder<ProfileMenuCubit, ProfileMenuState>(
            builder: (context, state) {
              if (state is ProfileMenuInitial || state is ProfileMenuLoading) {
                return const Center(
                  child: AppLoadingWidget(),
                );
              } else if (state is ProfileMenuError) {
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
                          context.read<ProfileMenuCubit>().loadProfile();
                        },
                        child: Text(LocaleKeys.app_common_retry.tr()),
                      ),
                    ],
                  ),
                );
              } else if (state is ProfileMenuLoaded) {
                return _buildMenuContent(state);
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildMenuContent(ProfileMenuLoaded state) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Header
          ProfileMenuHeader(
            bakeryName: state.profileData.bakeryName,
          ),
          // Divider
          Divider(
            height: 1.h,
            color: AppColors.textDarkBrown.withOpacity(0.2),
            thickness: 1,
          ),

          // Menu Items
          _buildMenuItems(),
        ],
      ),
    );
  }

  Widget _buildMenuItems() {
    return Column(
      children: [
        // Privacy Policy
        ProfileMenuItem(
          title: LocaleKeys.app_profile_settings_privacy_policy.tr(),
          icon: Icons.shield_outlined,
          onTap: () {
            // TODO: Navigate to privacy policy screen
          },
        ),
        // Technical Support
        ProfileMenuItem(
          title: LocaleKeys.app_profile_help_support_label.tr(),
          icon: Icons.headset_mic_outlined,
          onTap: () {
            // TODO: Navigate to support screen
          },
        ),
        // Settings
        ProfileMenuItem(
          title: LocaleKeys.app_navigation_settings.tr(),
          icon: Icons.settings_outlined,
          onTap: () {
            context.router.push(const SettingsRoute());
          },
        ),
        // Log Out
        ProfileMenuItem(
          title: LocaleKeys.app_general_logout.tr(),
          icon: Icons.logout,
          iconColor: AppColors.error,
          textColor: AppColors.error,
          onTap: _showLogoutDialog,
        ),
      ],
    );
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
