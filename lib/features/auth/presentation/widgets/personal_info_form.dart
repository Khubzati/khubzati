import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phone_form_field/phone_form_field.dart';

import '../../../../core/theme/styles/app_colors.dart';
import '../../../../core/theme/styles/app_text_style.dart';
import '../../../../core/widgets/shared_form_text_field_bloc.dart';
import '../../../../gen/translations/locale_keys.g.dart';
import '../../application/blocs/auth_bloc.dart';
import 'file_upload_widget.dart';

class PersonalInfoForm extends StatefulWidget {
  final Function(Map<String, dynamic>) onDataChanged;

  const PersonalInfoForm({
    super.key,
    required this.onDataChanged,
  });

  @override
  State<PersonalInfoForm> createState() => _PersonalInfoFormState();
}

class _PersonalInfoFormState extends State<PersonalInfoForm> {
  final _formKey = GlobalKey<FormState>();
  final _bakeryNameController = TextEditingController();
  final _locationController = TextEditingController();
  final _phoneController = PhoneController();

  String? _selectedFileName;
  Map<String, dynamic> _formData = {};

  @override
  void dispose() {
    _bakeryNameController.dispose();
    _locationController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _updateFormData() {
    _formData = {
      'bakeryName': _bakeryNameController.text,
      'location': _locationController.text,
      'phone': _phoneController.value,
      'attachment': _selectedFileName,
    };
    widget.onDataChanged(_formData);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is FileUploadSuccess) {
          setState(() {
            _selectedFileName = state.fileName;
          });
          _updateFormData();
        } else if (state is FileUploadError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bakery Name Field
            SharedFormTextFieldBloc(
              label: 'Bakery Name',
              hint: 'Enter your bakery name',
              prefixIcon: Icon(
                Icons.store_outlined,
                color: AppColors.primaryBurntOrange,
                size: 20.sp,
              ),
              onChanged: (value) {
                _bakeryNameController.text = value;
                _updateFormData();
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Bakery name is required';
                }
                return null;
              },
            ),
            16.verticalSpace,

            // Location Field
            SharedFormTextFieldBloc(
              label: 'Location',
              hint: 'Enter bakery location',
              prefixIcon: Icon(
                Icons.location_on_outlined,
                color: AppColors.primaryBurntOrange,
                size: 20.sp,
              ),
              onChanged: (value) {
                _locationController.text = value;
                _updateFormData();
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Location is required';
                }
                return null;
              },
            ),
            16.verticalSpace,

            // Phone Field
            _buildPhoneField(),
            16.verticalSpace,

            // File Upload Widget
            _buildFileUpload(),
          ],
        ),
      ),
    );
  }

  Widget _buildPhoneField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.app_form_phone_label.tr(),
          style: AppTextStyles.font16textDarkBrownBold,
        ),
        8.verticalSpace,
        PhoneFormField(
          controller: _phoneController,
          decoration: InputDecoration(
            hintText: LocaleKeys.app_form_phone_hint.tr(),
            hintStyle: TextStyle(
              color: AppColors.textDarkBrown.withOpacity(0.6),
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
            ),
            filled: true,
            fillColor: AppColors.creamColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(
                color: AppColors.primaryBurntOrange.withOpacity(0.3),
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(
                color: AppColors.primaryBurntOrange,
                width: 2,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 16.h,
            ),
            prefixIcon: Container(
              margin: EdgeInsets.all(8.w),
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: AppColors.primaryBurntOrange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                Icons.phone_android_rounded,
                color: AppColors.primaryBurntOrange,
                size: 20.sp,
              ),
            ),
          ),
          defaultCountry: IsoCode.JO,
          onChanged: (phone) => _updateFormData(),
          validator: (phone) {
            if (phone == null || phone.international.isEmpty) {
              return LocaleKeys.app_form_validation_required.tr();
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildFileUpload() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bakery License/Registration',
          style: AppTextStyles.font16textDarkBrownBold,
        ),
        8.verticalSpace,
        BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return FileUploadWidget(
              labelKey: 'Upload Document',
              buttonKey: 'Browse',
              placeHolder: 'No file selected',
              selectedFileName: _selectedFileName,
              onFileSelected: (filePath, fileName) {
                context.read<AuthBloc>().add(
                      FileUploadRequested(
                        filePath: filePath,
                        fileName: fileName,
                        uploadType: 'commercial_registry',
                      ),
                    );
              },
            );
          },
        ),
      ],
    );
  }

  bool validateForm() {
    return _formKey.currentState?.validate() ?? false;
  }

  Map<String, dynamic> getFormData() {
    return _formData;
  }
}
