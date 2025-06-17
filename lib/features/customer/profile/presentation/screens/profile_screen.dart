import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:khubzati/core/extensions/context.dart';
import 'package:khubzati/gen/translations/locale_keys.g.dart';

// TODO: Implement ProfileBloc for state management (fetching user data, updating profile, managing addresses)
// TODO: Implement UI for View/Edit Profile, Manage Addresses, Settings (Language, Notifications)
// TODO: Implement navigation to specific sub-screens like EditProfileScreen, ManageAddressesScreen, SettingsScreen

class ProfileScreen extends StatelessWidget {
  static const String routeName = '/profile';

  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Fetch user data using ProfileBloc

    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.profile_title.tr()), // Assuming this key exists
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // TODO: Implement User Profile Header (Avatar, Name, Email)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      // TODO: Add user avatar image
                      child: Icon(Icons.person, size: 50),
                    ),
                    const SizedBox(height: 16),
                    Text("User Name Placeholder", style: context.theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text("user.email@example.com", style: context.theme.textTheme.titleMedium?.copyWith(color: Colors.grey[600])),
                  ],
                ),
              ),
              const Divider(),

              // Menu Items
              _buildProfileMenuItem(
                context,
                icon: Icons.person_outline,
                title: LocaleKeys.profile_edit_profile_label.tr(), // Assuming this key exists
                onTap: () {
                  // TODO: Navigate to EditProfileScreen
                  print("Edit Profile Tapped");
                },
              ),
              _buildProfileMenuItem(
                context,
                icon: Icons.location_on_outlined,
                title: LocaleKeys.profile_manage_addresses_label.tr(), // Assuming this key exists
                onTap: () {
                  // TODO: Navigate to ManageAddressesScreen
                  print("Manage Addresses Tapped");
                },
              ),
              _buildProfileMenuItem(
                context,
                icon: Icons.history_outlined,
                title: LocaleKeys.profile_order_history_label.tr(), // Assuming this key exists
                onTap: () {
                  // TODO: Navigate to OrderHistoryScreen
                  print("Order History Tapped");
                  // Navigator.pushNamed(context, OrderHistoryScreen.routeName);
                },
              ),
              _buildProfileMenuItem(
                context,
                icon: Icons.notifications_none_outlined,
                title: LocaleKeys.profile_notifications_label.tr(), // Assuming this key exists
                onTap: () {
                  // TODO: Navigate to NotificationsSettingsScreen
                  print("Notifications Tapped");
                },
              ),
              _buildProfileMenuItem(
                context,
                icon: Icons.language_outlined,
                title: LocaleKeys.profile_language_label.tr(), // Assuming this key exists
                onTap: () {
                  // TODO: Navigate to LanguageSelectionScreen or show language dialog
                  print("Language Tapped");
                },
              ),
              _buildProfileMenuItem(
                context,
                icon: Icons.help_outline_outlined,
                title: LocaleKeys.profile_help_support_label.tr(), // Assuming this key exists
                onTap: () {
                  // TODO: Navigate to Help/Support Screen
                  print("Help & Support Tapped");
                },
              ),
              const Divider(),
              _buildProfileMenuItem(
                context,
                icon: Icons.logout_outlined,
                title: LocaleKeys.profile_logout_button.tr(), // Assuming this key exists
                textColor: context.colorScheme.error,
                onTap: () {
                  // TODO: Implement Logout logic (call AuthBloc, clear session, navigate to LoginScreen)
                  print("Logout Tapped");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileMenuItem(BuildContext context, {required IconData icon, required String title, VoidCallback? onTap, Color? textColor}) {
    return ListTile(
      leading: Icon(icon, color: textColor ?? context.colorScheme.onSurfaceVariant),
      title: Text(title, style: context.theme.textTheme.titleMedium?.copyWith(color: textColor)),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
      onTap: onTap,
    );
  }
}

