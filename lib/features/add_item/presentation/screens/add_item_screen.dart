import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:khubzati/core/theme/styles/app_colors.dart';
import 'package:khubzati/core/theme/styles/app_text_style.dart';
import 'package:khubzati/core/widgets/custom_drop_down.dart';
import 'package:khubzati/core/widgets/shared_app_background.dart';
import 'package:khubzati/core/widgets/shared_form_text_field_bloc.dart';
import 'package:khubzati/core/bloc/form/form_bloc.dart' as form_bloc;
import 'package:khubzati/core/routes/app_router.dart';
import 'package:khubzati/gen/assets.gen.dart';
import 'package:khubzati/gen/translations/locale_keys.g.dart';
import '../../application/blocs/add_item_bloc.dart';
import '../../application/blocs/add_item_event.dart';
import '../../data/datasources/add_item_datasource_impl.dart';
import '../../data/repositories/add_item_repository_impl.dart';
import '../../domain/entities/add_item_entity.dart';
import '../../domain/usecases/add_item_usecase.dart';

@RoutePage()
class AddItemScreen extends StatefulWidget {
  const AddItemScreen({super.key});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  late final form_bloc.FormBloc _formBloc;
  String _selectedType = '';
  String _selectedUnit = '';

  @override
  void initState() {
    super.initState();

    // Initialize FormBloc with validators
    _formBloc = form_bloc.FormBloc(
      initialValues: const {
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

    // Reset form to ensure clean state
    _resetForm();
  }

  void _resetForm() {
    // Reset form fields
    _formBloc.add(const form_bloc.FormFieldValueChanged(
      fieldId: 'name',
      value: '',
    ));
    _formBloc.add(const form_bloc.FormFieldValueChanged(
      fieldId: 'quantity',
      value: '',
    ));
    _formBloc.add(const form_bloc.FormFieldValueChanged(
      fieldId: 'price',
      value: '',
    ));
    _formBloc.add(const form_bloc.FormFieldValueChanged(
      fieldId: 'calories',
      value: '',
    ));

    // Reset dropdown selections
    setState(() {
      _selectedType = '';
      _selectedUnit = '';
    });
  }

  Future<void> _saveProduct() async {
    _formBloc.add(const form_bloc.FormValidationRequested());

    if (_formBloc.isFormValid &&
        _selectedType.isNotEmpty &&
        _selectedUnit.isNotEmpty) {
      final item = AddItemEntity(
        name: _formBloc.getFieldValue('name'),
        type: _selectedType,
        quantity: _formBloc.getFieldValue('quantity'),
        unit: _selectedUnit,
        price: _formBloc.getFieldValue('price'),
        calories: _formBloc.getFieldValue('calories'),
        imageUrl: '',
      );

      // Create AddItemBloc and dispatch the event
      final addItemBloc = AddItemBloc(
        addItemUseCase: AddItemUseCase(
          repository: AddItemRepositoryImpl(
            dataSource: AddItemDataSourceImpl(),
          ),
        ),
      );

      addItemBloc.add(AddItemSubmitted(item: item));

      if (mounted) {
        // Show success modal
        _showSuccessBottomSheet();
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
        color: AppColors.secondaryLightCream,
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
                100.verticalSpace, // Space for the illustration

                // Success message
                Text(
                  LocaleKeys.app_bread_type_success_title.tr(),
                  style: AppTextStyles.font20textDarkBrownbold,
                  textAlign: TextAlign.center,
                ),
                48.verticalSpace,

                // Action buttons
                Row(
                  children: [
                    // View Details button
                    Expanded(
                      child: SizedBox(
                        height: 48.h,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            context.router
                                .push(MainNavigationRoute(initialIndex: 1));
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: AppColors.primaryBurntOrange,
                              width: 1.w,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            backgroundColor: AppColors.secondaryLightCream,
                          ),
                          child: Text(
                            LocaleKeys.app_bread_type_view_details.tr(),
                            style: AppTextStyles.font16TextW500.copyWith(
                              color: AppColors.primaryBurntOrange,
                            ),
                          ),
                        ),
                      ),
                    ),
                    16.horizontalSpace,
                    // Add New Item button
                    Expanded(
                      child: SizedBox(
                        height: 48.h,
                        child: ElevatedButton(
                          onPressed: () {
                            context.router.push(const AddItemRoute());
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryBurntOrange,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                          child: Text(
                            LocaleKeys.app_bread_type_add_new_item.tr(),
                            style: AppTextStyles.font16TextW500.copyWith(
                              color: AppColors.secondaryLightCream,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                32.verticalSpace,
              ],
            ),
          ),
          // Chef illustration positioned at the top
          Positioned(
            top: -100.h,
            left: 0,
            right: 0,
            child: Center(
              child: SvgPicture.asset(
                Assets.images.successMessage,
              ),
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
                            items: [
                              LocaleKeys.app_bread_type_type_bread.tr(),
                              LocaleKeys.app_bread_type_type_pastry.tr(),
                              LocaleKeys.app_bread_type_type_sweets.tr(),
                            ],
                            selectedItem: [
                              LocaleKeys.app_bread_type_type_bread.tr(),
                              LocaleKeys.app_bread_type_type_pastry.tr(),
                              LocaleKeys.app_bread_type_type_sweets.tr(),
                            ].contains(_selectedType)
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
                            items: [
                              LocaleKeys.app_bread_type_unit_kilo.tr(),
                              LocaleKeys.app_bread_type_unit_piece.tr(),
                              LocaleKeys.app_bread_type_unit_box.tr(),
                            ],
                            selectedItem: [
                              LocaleKeys.app_bread_type_unit_kilo.tr(),
                              LocaleKeys.app_bread_type_unit_piece.tr(),
                              LocaleKeys.app_bread_type_unit_box.tr(),
                            ].contains(_selectedUnit)
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
            left: 200.w,
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
                  LocaleKeys.app_bread_type_add_new_item_title.tr(),
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
