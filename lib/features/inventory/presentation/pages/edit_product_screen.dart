import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:khubzati/core/theme/styles/app_colors.dart';
import 'package:khubzati/core/widgets/shared_app_background.dart';
import 'package:khubzati/core/widgets/shared_form_text_field_bloc.dart';
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
      _formBloc.add(const form_bloc.FormSubmitted());

      try {
        // Simulate API call
        await Future.delayed(const Duration(seconds: 1));

        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'تم حفظ التعديلات بنجاح',
                style: TextStyle(
                  color: Color(0xFFF9F2E4),
                  fontFamily: 'Tajawal',
                ),
              ),
              backgroundColor: Color(0xFFC25E3E),
              duration: Duration(seconds: 2),
            ),
          );

          // Navigate back
          context.router.maybePop();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'حدث خطأ أثناء الحفظ',
                style: TextStyle(
                  color: Color(0xFFF9F2E4),
                  fontFamily: 'Tajawal',
                ),
              ),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    }
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
                          _buildDropdownField(
                            label: LocaleKeys.app_bread_type_type.tr(),
                            hint:
                                LocaleKeys.app_bread_type_type_placeholder.tr(),
                            value: _selectedType,
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
                          _buildDropdownField(
                            label: LocaleKeys.app_bread_type_unit.tr(),
                            hint:
                                LocaleKeys.app_bread_type_unit_placeholder.tr(),
                            value: _selectedUnit,
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
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 17),
                            child: Text(
                              LocaleKeys.app_inventory_nutritional_value.tr(),
                              style: TextStyle(
                                color: const Color(0xFF67392A),
                                fontSize: 16.sp,
                                fontFamily: 'Tajawal',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
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
                      backgroundColor: const Color(0xFFC25E3E),
                      disabledBackgroundColor:
                          const Color(0xFFC25E3E).withValues(alpha: 0.5),
                      foregroundColor: const Color(0xFFF9F2E4),
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
                                Color(0xFFF9F2E4),
                              ),
                            ),
                          )
                        : Text(
                            LocaleKeys.app_bread_type_submit.tr(),
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontFamily: 'Tajawal',
                              fontWeight: FontWeight.w500,
                            ),
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
                    color: const Color(0xFFF9F2E4),
                  ),
                ),
                Text(
                  LocaleKeys.app_inventory_editCategory.tr(),
                  style: TextStyle(
                    color: const Color(0xFFF9F2E4),
                    fontSize: 20.sp,
                    fontFamily: 'Tajawal',
                    fontWeight: FontWeight.w700,
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

  Widget _buildDropdownField({
    required String label,
    required String hint,
    required String value,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Floating label
          SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  color: const Color(0xFFF8F2E8),
                  padding: const EdgeInsets.only(
                      top: 4, bottom: 4, left: 5, right: 5),
                  margin: const EdgeInsets.only(right: 11),
                  child: Text(
                    label,
                    style: TextStyle(
                      color: const Color(0xFF67392A),
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Dropdown field
          GestureDetector(
            onTap: () {
              // TODO: Implement dropdown functionality
              print('Dropdown pressed');
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color(0x75965641),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(8.r),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Transform.rotate(
                    angle: -1.57, // -90 degrees
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: const Color(0x75965641),
                      size: 20.sp,
                    ),
                  ),
                  Text(
                    value.isEmpty ? hint : value,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: value.isEmpty
                          ? const Color(0x75965641)
                          : const Color(0xFF67392A),
                      fontSize: 12.sp,
                      fontFamily: 'Tajawal',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
