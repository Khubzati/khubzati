import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:khubzati/features/auth/presentation/widgets/widgets.dart';
import '../../../../core/widgets/shared_form_text_field_bloc.dart';

import '../../../../core/theme/styles/app_colors.dart';
import '../../../../core/theme/styles/app_text_style.dart';
import '../../../../gen/translations/locale_keys.g.dart';

class PersonalInfoStep extends StatefulWidget {
  final Function(Map<String, dynamic>) onDataChanged;
  final Function() onNext;

  const PersonalInfoStep({
    super.key,
    required this.onDataChanged,
    required this.onNext,
  });

  @override
  State<PersonalInfoStep> createState() => _PersonalInfoStepState();
}

class _PersonalInfoStepState extends State<PersonalInfoStep> {
  final _formKey = GlobalKey<FormState>();
  final _bakeryNameController = TextEditingController();
  final _locationController = TextEditingController();
  final _phoneController = TextEditingController();

  String? _selectedCommercialRegistryFileName;
  String? _selectedLogoFileName;
  bool _isFormValid = false;

  @override
  void dispose() {
    _bakeryNameController.dispose();
    _locationController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _validateForm() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (isValid != _isFormValid) {
      setState(() {
        _isFormValid = isValid;
      });
    }
  }

  void _updateFormData() {
    final data = {
      'bakeryName': _bakeryNameController.text,
      'location': _locationController.text,
      'phone': _phoneController.text,
      'commercialRegistry': _selectedCommercialRegistryFileName,
      'logo': _selectedLogoFileName,
    };
    widget.onDataChanged(data);
    _validateForm();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            LocaleKeys.app_auth_signup_heading.tr(),
            style: AppTextStyles.font20textDarkBrownbold,
          ),
          8.verticalSpace,
          Text(
            LocaleKeys.app_auth_signup_subheading.tr(),
            style: AppTextStyles.font15TextW400,
          ),
          32.verticalSpace,

          // Bakery Name Field
          SharedFormTextFieldBloc(
            label: LocaleKeys.app_signup_app_signup_bakeryName.tr(),
            hint: LocaleKeys.app_signup_app_signup_enterBakeryName.tr(),
            prefixIcon: Icon(
              Icons.store_outlined,
              color: AppColors.primaryBurntOrange,
              size: 20.sp,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return LocaleKeys.app_form_validation_required.tr();
              }
              return null;
            },
            onChanged: (value) {
              _bakeryNameController.text = value;
              _updateFormData();
            },
          ),
          16.verticalSpace,

          // Location Field
          SharedFormTextFieldBloc(
            label: LocaleKeys.app_signup_app_signup_location.tr(),
            hint: LocaleKeys.app_signup_app_signup_location_hint.tr(),
            prefixIcon: Icon(
              Icons.location_on_outlined,
              color: AppColors.primaryBurntOrange,
              size: 20.sp,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return LocaleKeys.app_form_validation_required.tr();
              }
              return null;
            },
            onChanged: (value) {
              _locationController.text = value;
              _updateFormData();
            },
          ),
          16.verticalSpace,

          // Phone Field
          PhoneInputWidget(
            controller: _phoneController,
            onChanged: (phone) => _updateFormData(),
          ),
          16.verticalSpace,

          // File Upload Widget (reusable)
          LabeledFileUpload(
            labelKey: LocaleKeys.app_signup_app_signup_commercialRegistry,
            buttonKey: LocaleKeys.app_signup_app_signup_chooseFile,
            placeHolder: LocaleKeys.app_signup_attach_files_again,
            selectedFileName: _selectedCommercialRegistryFileName,
            onFileSelected: (path, name) {
              setState(() {
                _selectedCommercialRegistryFileName = name;
              });
              _updateFormData();
            },
          ),
          16.verticalSpace,
          // File Upload Widget (reusable)
          LabeledFileUpload(
            labelKey: LocaleKeys.app_signup_app_signup_bakeryLogo,
            buttonKey: LocaleKeys.app_signup_app_signup_chooseFile,
            placeHolder: LocaleKeys.app_signup_attach_files_again,
            selectedFileName: _selectedLogoFileName,
            onFileSelected: (path, name) {
              setState(() {
                _selectedLogoFileName = name;
              });
              _updateFormData();
            },
          ),

          40.verticalSpace,

          // Next Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isFormValid ? widget.onNext : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBurntOrange,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                elevation: 0,
              ),
              child: Text(
                LocaleKeys.app_signup_app_signup_next.tr(),
                style: AppTextStyles.font16TextW500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Removed local _buildFileUpload in favor of reusable LabeledFileUpload
}
