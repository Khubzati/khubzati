import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:khubzati/core/theme/styles/app_colors.dart';
import 'package:khubzati/core/theme/styles/app_text_style.dart';
import 'package:khubzati/core/widgets/custom_drop_down.dart';
import 'package:khubzati/core/widgets/shared_app_background.dart';
import 'package:khubzati/core/widgets/shared_form_text_field_bloc.dart';
import 'package:khubzati/gen/assets.gen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:khubzati/core/bloc/form/form_bloc.dart' as form_bloc;
import 'package:khubzati/gen/translations/locale_keys.g.dart';

@RoutePage()
class EditProductScreen extends StatefulWidget {
  final String productId;
  final String name;
  final String description;
  final String price;
  final String quantity;
  final String unit;
  final String imageUrl;

  const EditProductScreen({
    super.key,
    required this.productId,
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
    required this.unit,
    required this.imageUrl,
  });

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  late final form_bloc.FormBloc _formBloc;
  String _selectedType = '';
  String _selectedUnit = '';

  @override
  void initState() {
    super.initState();
    _selectedUnit = widget.unit;

    // Initialize FormBloc with initial values and validators
    _formBloc = form_bloc.FormBloc(
      initialValues: {
        'name': widget.name,
        'quantity': widget.quantity,
        'price': widget.price,
        'calories': '150', // Default calories
      },
      validators: {
        'name': (value) {
          if (value == null || value.trim().isEmpty) {
            return 'يرجى إدخال اسم الصنف';
          }
          return null;
        },
        'quantity': (value) {
          if (value == null || value.trim().isEmpty) {
            return 'يرجى إدخال الكمية';
          }
          if (double.tryParse(value) == null) {
            return 'يرجى إدخال رقم صحيح';
          }
          return null;
        },
        'price': (value) {
          if (value == null || value.trim().isEmpty) {
            return 'يرجى إدخال السعر';
          }
          if (double.tryParse(value) == null) {
            return 'يرجى إدخال رقم صحيح';
          }
          return null;
        },
        'calories': (value) {
          if (value == null || value.trim().isEmpty) {
            return 'يرجى إدخال السعرات الحرارية';
          }
          if (int.tryParse(value) == null) {
            return 'يرجى إدخال رقم صحيح';
          }
          return null;
        },
      },
    );
  }

  Future<void> _saveProduct() async {
    _formBloc.add(const form_bloc.FormValidationRequested());

    if (_formBloc.isFormValid) {
      _showConfirmationBottomSheet();
    }
  }

  void _showConfirmationBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildConfirmationBottomSheet(),
    );
  }

  Widget _buildConfirmationBottomSheet() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.creamColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.r),
          topRight: Radius.circular(25.r),
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                100.verticalSpace, // Space for the SVG that will be positioned

                // Confirmation message
                Text(
                  LocaleKeys.app_inventory_confirmation_message.tr(),
                  style: AppTextStyles.font20textDarkBrownbold,
                  textAlign: TextAlign.center,
                ),
                32.verticalSpace,

                // Action buttons
                Row(
                  children: [
                    // No button
                    Expanded(
                      child: SizedBox(
                        height: 48.h,
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: AppColors.primaryBurntOrange,
                              width: 1.w,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            backgroundColor: AppColors.creamColor,
                          ),
                          child: Text(
                            LocaleKeys.app_inventory_confirmation_no_button
                                .tr(),
                            style: AppTextStyles.font16textDarkBrownBold,
                          ),
                        ),
                      ),
                    ),
                    16.horizontalSpace,

                    // Yes button
                    Expanded(
                      child: SizedBox(
                        height: 48.h,
                        child: ElevatedButton(
                          onPressed: _confirmSave,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryBurntOrange,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            LocaleKeys.app_inventory_confirmation_yes_button
                                .tr(),
                            style: AppTextStyles.font16TextW500.copyWith(
                              color: AppColors.secondaryLightCream,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                24.verticalSpace,
              ],
            ),
          ),
          // Baker illustration positioned at the top
          Positioned(
            top: -100,
            left: 0,
            right: 0,
            child: SvgPicture.asset(
              Assets.images.editSuccessfully,
              height: 200.h,
              width: 200.w,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmSave() async {
    Navigator.of(context).pop(); // Close confirmation bottom sheet

    _formBloc.add(const form_bloc.FormSubmitted());

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Show success bottom sheet
      if (mounted) {
        _showSuccessBottomSheet();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              LocaleKeys.app_inventory_error.tr(),
              style: AppTextStyles.font16TextW500.copyWith(
                color: AppColors.secondaryLightCream,
              ),
            ),
            backgroundColor: AppColors.error,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  void _showSuccessBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildSuccessBottomSheet(),
    );
  }

  Widget _buildSuccessBottomSheet() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.creamColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.r),
          topRight: Radius.circular(25.r),
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                100.verticalSpace, // Space for the SVG that will be positioned

                // Success message
                Text(
                  LocaleKeys.app_inventory_save_success.tr(),
                  style: AppTextStyles.font20textDarkBrownbold,
                  textAlign: TextAlign.center,
                ),
                32.verticalSpace,

                // OK button
                SizedBox(
                  width: double.infinity,
                  height: 48.h,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close success bottom sheet
                      context.router
                          .maybePop(); // Navigate back to previous screen
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBurntOrange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      LocaleKeys.app_inventory_ok_button.tr(),
                      style: AppTextStyles.font16TextW500.copyWith(
                        color: AppColors.secondaryLightCream,
                      ),
                    ),
                  ),
                ),
                24.verticalSpace,
              ],
            ),
          ),
          // Success illustration positioned at the top
          Positioned(
            top: -100,
            left: 0,
            right: 0,
            child: SvgPicture.asset(
              Assets.images.successMessage,
              height: 200.h,
              width: 200.w,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _formBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _formBloc,
      child: Scaffold(
        backgroundColor: AppColors.creamColor,
        body: Stack(
          children: [
            // Main content
            Positioned.fill(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with background
                    _buildHeader(context),

                    // Form content
                    Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 24.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // Product Name Field
                          SharedFormTextFieldBlocVariants.standard(
                            label: LocaleKeys.app_bread_type_name.tr(),
                            hint:
                                LocaleKeys.app_bread_type_name_placeholder.tr(),
                            initialValue: widget.name,
                            onChanged: (value) {
                              _formBloc.add(form_bloc.FormFieldValueChanged(
                                fieldId: 'name',
                                value: value,
                              ));
                            },
                          ),
                          16.verticalSpace,
                          // Product Type Field
                          CustomDropDown(
                            label: LocaleKeys.app_bread_type_type.tr(),
                            hintText:
                                LocaleKeys.app_bread_type_type_placeholder.tr(),
                            items: const ['خبز', 'معجنات', 'حلويات'],
                            selectedItem: ['خبز', 'معجنات', 'حلويات']
                                    .contains(_selectedType)
                                ? _selectedType
                                : null,
                            onChanged: (value) {
                              setState(() {
                                _selectedType = value ?? '';
                              });
                            },
                          ),
                          16.verticalSpace,

                          // Quantity Field
                          SharedFormTextFieldBlocVariants.number(
                            label: LocaleKeys.app_bread_type_quantity.tr(),
                            hint: LocaleKeys.app_bread_type_quantity_placeholder
                                .tr(),
                            initialValue: widget.quantity,
                            onChanged: (value) {
                              _formBloc.add(form_bloc.FormFieldValueChanged(
                                fieldId: 'quantity',
                                value: value,
                              ));
                            },
                          ),
                          16.verticalSpace,

                          // Unit Field
                          CustomDropDown(
                            label: LocaleKeys.app_bread_type_unit.tr(),
                            hintText:
                                LocaleKeys.app_bread_type_unit_placeholder.tr(),
                            items: const ['كيلو', 'قطعة', 'صندوق'],
                            selectedItem: ['كيلو', 'قطعة', 'صندوق']
                                    .contains(_selectedUnit)
                                ? _selectedUnit
                                : null,
                            onChanged: (value) {
                              setState(() {
                                _selectedUnit = value ?? '';
                              });
                            },
                          ),
                          16.verticalSpace,

                          // Price Field
                          SharedFormTextFieldBlocVariants.number(
                            label: LocaleKeys.app_bread_type_price.tr(),
                            hint: LocaleKeys.app_bread_type_price_placeholder
                                .tr(),
                            initialValue: widget.price,
                            onChanged: (value) {
                              _formBloc.add(form_bloc.FormFieldValueChanged(
                                fieldId: 'price',
                                value: value,
                              ));
                            },
                          ),
                        ],
                      ),
                    ),

                    // Nutritional Value Section
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Text(
                                LocaleKeys.app_inventory_nutritional_value.tr(),
                                style: AppTextStyles.font20textDarkBrownbold),
                          ),
                        ],
                      ),
                    ),

                    // Calories Field
                    Container(
                      margin: const EdgeInsets.only(
                          bottom: 143, left: 16, right: 16),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SharedFormTextFieldBlocVariants.number(
                            label: LocaleKeys.app_bread_type_calories.tr(),
                            hint: LocaleKeys.app_bread_type_calories_placeholder
                                .tr(),
                            initialValue: '150',
                            onChanged: (value) {
                              _formBloc.add(form_bloc.FormFieldValueChanged(
                                fieldId: 'calories',
                                value: value,
                              ));
                            },
                          ),
                        ],
                      ),
                    ),

                    // Bottom spacing (content ends before fixed button)
                    24.verticalSpace,
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
            child: BlocBuilder<form_bloc.FormBloc, form_bloc.FormState>(
              builder: (context, state) {
                final hasChanges =
                    state is form_bloc.FormUpdated ? state.hasChanges : false;
                final isValid =
                    state is form_bloc.FormUpdated ? state.isValid : false;
                final isSubmitting =
                    state is form_bloc.FormUpdated ? state.isSubmitting : false;

                return SizedBox(
                  width: double.infinity,
                  height: 48.h,
                  child: ElevatedButton(
                    onPressed: hasChanges && isValid && !isSubmitting
                        ? _saveProduct
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBurntOrange,
                      disabledBackgroundColor:
                          AppColors.primaryBurntOrange.withValues(alpha: 0.5),
                      foregroundColor: AppColors.secondaryLightCream,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      elevation: hasChanges && isValid && !isSubmitting ? 4 : 0,
                    ),
                    child: isSubmitting
                        ? SizedBox(
                            width: 20.w,
                            height: 20.h,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.secondaryLightCream,
                              ),
                            ),
                          )
                        : Text(
                            LocaleKeys.app_bread_type_submit.tr(),
                            style: AppTextStyles.font16TextW500,
                          ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 125.h,
      child: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: SharedAppBackground(
              fit: BoxFit.cover,
              child: Container(
                color: Colors.black.withValues(alpha: 0.3),
              ),
            ),
          ),
          // Title and back arrow
          Positioned(
            left: 216.w,
            top: 71.h,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () => context.router.maybePop(),
                  icon: Icon(
                    Icons.arrow_back_ios,
                    size: 24.sp,
                    color: AppColors.secondaryLightCream,
                  ),
                ),
                Text(
                  LocaleKeys.app_inventory_editCategory.tr(),
                  style: AppTextStyles.font20TextW500.copyWith(
                    color: AppColors.secondaryLightCream,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
