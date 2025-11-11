import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:khubzati/features/auth/application/blocs/auth_bloc.dart';
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
  String? _commercialRegistryFilePath;
  String? _commercialRegistryFileUrl;
  String? _logoFilePath;
  String? _logoFileUrl;
  String? _phoneNumber; // Store phone number separately
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
      'phone': _phoneNumber ?? _phoneController.text,
      'commercialRegistry':
          _commercialRegistryFileUrl ?? _selectedCommercialRegistryFileName,
      'logo': _logoFileUrl ?? _selectedLogoFileName,
    };
    widget.onDataChanged(data);
    _validateForm();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      bloc: GetIt.instance<AuthBloc>(),
      listener: (context, state) {
        if (state is FileUploadSuccess) {
          if (state.uploadType == 'commercial_registry') {
            setState(() {
              _commercialRegistryFileUrl = state.fileUrl;
            });
            _updateFormData();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Commercial registry uploaded successfully'),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 2),
              ),
            );
          } else if (state.uploadType == 'logo') {
            setState(() {
              _logoFileUrl = state.fileUrl;
            });
            _updateFormData();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Logo uploaded successfully'),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 2),
              ),
            );
          }
        } else if (state is FileUploadError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      },
      child: Form(
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
              onChanged: (phone) {
                // IntlPhoneField onChanged receives PhoneNumber object
                // Extract complete number (includes country code)
                if (phone != null) {
                  try {
                    // PhoneNumber object from intl_phone_field has completeNumber property
                    _phoneNumber = phone.completeNumber;
                  } catch (e) {
                    // Fallback: use controller text if available
                    _phoneNumber = _phoneController.text.isNotEmpty
                        ? _phoneController.text
                        : phone.toString();
                  }
                }
                _updateFormData();
              },
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
                  _commercialRegistryFilePath = path;
                });

                // Trigger file upload
                GetIt.instance<AuthBloc>().add(
                  FileUploadRequested(
                    filePath: path,
                    fileName: name,
                    uploadType: 'commercial_registry',
                  ),
                );

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
                  _logoFilePath = path;
                });

                // Trigger file upload
                GetIt.instance<AuthBloc>().add(
                  FileUploadRequested(
                    filePath: path,
                    fileName: name,
                    uploadType: 'logo',
                  ),
                );

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
      ),
    );
  }

  // Removed local _buildFileUpload in favor of reusable LabeledFileUpload
}
