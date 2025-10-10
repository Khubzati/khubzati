import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:khubzati/core/theme/styles/app_colors.dart';
import 'package:khubzati/core/theme/styles/app_text_style.dart';
import 'package:khubzati/core/widgets/shared_form_text_field.dart';
import 'package:khubzati/gen/translations/locale_keys.g.dart';

@RoutePage()
class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _bakeryNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize with default values (similar to SwiftUI @State)
    _bakeryNameController.text = "مخبز البدر";
    _addressController.text = "عمان، وادي السير، الدوار السابع";
    _phoneNumberController.text = "+962 70 000 0000";
  }

  @override
  void dispose() {
    _bakeryNameController.dispose();
    _addressController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      body: SafeArea(
        child: Column(
          children: [
            // Header with background image
            _buildHeader(),

            // Profile content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(height: 60.h), // Space for profile image

                      // Profile Image
                      _buildProfileImage(),

                      SizedBox(height: 24.h),

                      // Form Fields
                      _buildFormFields(),

                      SizedBox(height: 100.h), // Space for bottom button
                    ],
                  ),
                ),
              ),
            ),

            // Bottom Button
            _buildBottomButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 125.h,
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: NetworkImage(
            "https://api.builder.io/api/v1/image/assets/TEMP/de10d90a694f734400b0d04df185773f2f050380?width=780",
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.1),
        ),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            LocaleKeys.app_profile_title.tr(),
            style: AppTextStyles.font24TextW700.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return Stack(
      children: [
        Container(
          width: 120.w,
          height: 120.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(
            Icons.person,
            size: 60,
            color: AppColors.primaryBurntOrange,
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            width: 32.w,
            height: 32.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryBurntOrange,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: const Icon(
              Icons.camera_alt,
              size: 16,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFormFields() {
    return Column(
      children: [
        // Bakery Name Field
        SharedFormTextFieldVariants.standard(
          controller: _bakeryNameController,
          label: LocaleKeys.app_profile_bakery_name.tr(),
          hint: LocaleKeys.app_profile_bakery_name_hint.tr(),
          isRequired: true,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return LocaleKeys.app_profile_bakery_name_required.tr();
            }
            return null;
          },
        ),

        SizedBox(height: 16.h),

        // Address Field
        SharedFormTextFieldVariants.standard(
          controller: _addressController,
          label: LocaleKeys.app_profile_address.tr(),
          hint: LocaleKeys.app_profile_address_hint.tr(),
          isRequired: true,
          // maxLines: 2,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return LocaleKeys.app_profile_address_required.tr();
            }
            return null;
          },
        ),

        SizedBox(height: 16.h),

        // Phone Number Field
        SharedFormTextFieldVariants.phone(
          controller: _phoneNumberController,
          label: LocaleKeys.app_profile_phone_number.tr(),
          hint: LocaleKeys.app_profile_phone_number_hint.tr(),
          isRequired: true,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return LocaleKeys.app_profile_phone_number_required.tr();
            }
            // Basic phone validation
            if (!RegExp(r'^\+?[0-9\s\-\(\)]+$').hasMatch(value)) {
              return LocaleKeys.app_profile_phone_number_invalid.tr();
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildBottomButton() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: AppColors.pageBackground,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 9,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 48.h,
        child: ElevatedButton(
          onPressed: _handleSave,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryBurntOrange,
            foregroundColor: AppColors.pageBackground,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
            elevation: 0,
          ),
          child: Text(
            LocaleKeys.app_profile_edit_info.tr(),
            style: AppTextStyles.font16TextW500.copyWith(
              fontWeight: FontWeight.w500,
              color: AppColors.pageBackground,
            ),
          ),
        ),
      ),
    );
  }

  void _handleSave() {
    if (_formKey.currentState?.validate() ?? false) {
      // TODO: Implement save logic
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(LocaleKeys.app_profile_save_success.tr()),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }
}
