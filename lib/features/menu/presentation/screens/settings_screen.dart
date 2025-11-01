import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:khubzati/core/di/injection.dart';
import 'package:khubzati/core/theme/styles/app_colors.dart';
import 'package:khubzati/core/theme/styles/app_text_style.dart';
import 'package:khubzati/core/widgets/shared/app_loading_widget.dart';
import 'package:khubzati/features/menu/application/blocs/settings/settings_cubit.dart';
import 'package:khubzati/features/menu/application/blocs/settings/settings_state.dart';
import 'package:khubzati/features/menu/presentation/widgets/settings_header.dart';
import 'package:khubzati/features/menu/presentation/widgets/settings_item.dart';
import 'package:khubzati/features/menu/presentation/widgets/delete_account_dialog.dart';
import 'package:khubzati/features/menu/presentation/widgets/language_selection_dialog.dart';
import 'package:khubzati/gen/translations/locale_keys.g.dart';

@RoutePage()
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SettingsCubit>(
      create: (context) => getIt<SettingsCubit>()..loadSettings(),
      child: const _SettingsScreenView(),
    );
  }
}

class _SettingsScreenView extends StatelessWidget {
  const _SettingsScreenView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            // Header with blurred background
            const SettingsHeader(),
            // Main Content
            Expanded(
              child: BlocBuilder<SettingsCubit, SettingsState>(
                builder: (context, state) {
                  if (state is SettingsInitial || state is SettingsLoading) {
                    return const Center(
                      child: AppLoadingWidget(),
                    );
                  } else if (state is SettingsError) {
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
                              context.read<SettingsCubit>().loadSettings();
                            },
                            child: Text(LocaleKeys.app_common_retry.tr()),
                          ),
                        ],
                      ),
                    );
                  } else if (state is SettingsLoaded) {
                    return _buildSettingsContent(context, state);
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsContent(BuildContext context, SettingsLoaded state) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Language Setting
          SettingsItem(
            title: LocaleKeys.app_settings_language.tr(),
            icon: Icons.language,
            onTap: () {
              LanguageSelectionDialog.show(
                context: context,
                currentLanguage: state.currentLanguage,
                onLanguageSelected: (languageCode) {
                  context
                      .read<SettingsCubit>()
                      .changeLanguage(languageCode, context);
                },
              );
            },
          ),
          // Notifications Setting
          SettingsItem(
            title: LocaleKeys.app_settings_notifications.tr(),
            icon: Icons.notifications_outlined,
            showToggle: true,
            toggleValue: state.isNotificationsEnabled,
            onToggleChanged: (value) {
              context.read<SettingsCubit>().toggleNotifications(value);
            },
          ),
          // Delete Account Option
          SettingsItem(
            title: LocaleKeys.app_settings_delete_account.tr(),
            icon: Icons.delete_outline,
            iconColor: AppColors.error,
            textColor: AppColors.error,
            showDivider: false,
            onTap: () {
              DeleteAccountDialog.show(
                context: context,
                onConfirm: () {
                  // TODO: Implement delete account functionality
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        LocaleKeys.app_settings_delete_account_success.tr(),
                      ),
                      backgroundColor: AppColors.success,
                      behavior: SnackBarBehavior.fixed,
                      duration: const Duration(seconds: 3),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
