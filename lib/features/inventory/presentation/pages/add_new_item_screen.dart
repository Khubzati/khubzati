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
import 'package:khubzati/core/bloc/form/form_bloc.dart' as form_bloc;
import 'package:khubzati/gen/translations/locale_keys.g.dart';
import '../../application/blocs/inventory_bloc.dart';

@RoutePage()
class AddNewItemScreen extends StatefulWidget {
  const AddNewItemScreen({super.key});

  @override
  State<AddNewItemScreen> createState() => _AddNewItemScreenState();
}

class _AddNewItemScreenState extends State<AddNewItemScreen> {
  late final form_bloc.FormBloc _formBloc;
  String _selectedType = '';
  String _selectedUnit = '';

  @override
  void initState() {
    super.initState();

    // Initialize FormBloc with validators
    _formBloc = form_bloc.FormBloc(
      initialValues: {
        'name': '',
        'quantity': '',
        'price': '',
        'calories': '',
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
      // Add the new item to inventory
      context.read<InventoryBloc>().add(
            AddInventoryItem(
              name: _formBloc.getFieldValue('name'),
              description: '', // We can add description field later if needed
              price: _formBloc.getFieldValue('price'),
              quantity: _formBloc.getFieldValue('quantity'),
              unit: _selectedUnit,
              imageUrl: '', // We can add image upload later if needed
            ),
          );

      // Navigate back to inventory screen
      context.router.maybePop();
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
                          Text(
                            LocaleKeys.app_inventory_nutritional_value.tr(),
                            style: AppTextStyles.font16textDarkBrownBold,
                          ),
                          16.verticalSpace,
                          // Calories Field
                          SharedFormTextFieldBlocVariants.number(
                            label: LocaleKeys.app_bread_type_calories.tr(),
                            hint: LocaleKeys.app_bread_type_calories_placeholder
                                .tr(),
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

                    // Save Button
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16.w),
                      width: double.infinity,
                      height: 48.h,
                      child: ElevatedButton(
                        onPressed: _saveProduct,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryBurntOrange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          LocaleKeys.app_bread_type_submit.tr(),
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
            ),
          ],
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
            left: 16.w,
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
                  'إضافة صنف جديد',
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
