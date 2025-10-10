import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:khubzati/core/routes/app_router.dart';

import '../../../../core/theme/styles/app_colors.dart';
import '../../../../core/theme/styles/app_text_style.dart';
import '../../../../gen/translations/locale_keys.g.dart';

class BreadInfoStep extends StatefulWidget {
  final Function(Map<String, dynamic>) onDataChanged;
  final VoidCallback onNext;
  final String phoneNumber; // Add phone number for OTP

  const BreadInfoStep({
    super.key,
    required this.onDataChanged,
    required this.onNext,
    required this.phoneNumber,
  });

  @override
  State<BreadInfoStep> createState() => _BreadInfoStepState();
}

class _BreadInfoStepState extends State<BreadInfoStep> {
  final _formKey = GlobalKey<FormState>();
  final List<Map<String, dynamic>> _breadTypes = [];
  final List<TextEditingController> _nameControllers = [];
  final List<TextEditingController> _quantityControllers = [];
  final List<TextEditingController> _priceControllers = [];
  final List<TextEditingController> _caloriesControllers = [];
  final List<String?> _selectedTypes = [];
  final List<String?> _selectedUnits = [];
  final List<bool> _isExpanded = [];

  @override
  void initState() {
    super.initState();
    _addBreadType(); // Start with one bread type
  }

  @override
  void dispose() {
    for (var controller in _nameControllers) {
      controller.dispose();
    }
    for (var controller in _quantityControllers) {
      controller.dispose();
    }
    for (var controller in _priceControllers) {
      controller.dispose();
    }
    for (var controller in _caloriesControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addBreadType() {
    setState(() {
      _nameControllers.add(TextEditingController());
      _quantityControllers.add(TextEditingController());
      _priceControllers.add(TextEditingController());
      _caloriesControllers.add(TextEditingController());
      _selectedTypes.add(null);
      _selectedUnits.add(null);
      _isExpanded.add(true); // New bread types start expanded
      _breadTypes.add({});
    });
    _updateFormData();
  }

  void _toggleExpansion(int index) {
    setState(() {
      _isExpanded[index] = !_isExpanded[index];
    });
  }

  void _deleteBreadType(int index) {
    if (_breadTypes.length > 1) {
      // Keep at least one bread type
      setState(() {
        _nameControllers[index].dispose();
        _quantityControllers[index].dispose();
        _priceControllers[index].dispose();
        _caloriesControllers[index].dispose();

        _nameControllers.removeAt(index);
        _quantityControllers.removeAt(index);
        _priceControllers.removeAt(index);
        _caloriesControllers.removeAt(index);
        _selectedTypes.removeAt(index);
        _selectedUnits.removeAt(index);
        _isExpanded.removeAt(index);
        _breadTypes.removeAt(index);
      });
      _updateFormData();
    }
  }

  void _updateFormData() {
    final data = <String, dynamic>{
      'breadTypes': _breadTypes,
    };
    widget.onDataChanged(data);
  }

  void _updateBreadType(int index) {
    if (index < _breadTypes.length) {
      _breadTypes[index] = {
        'name': _nameControllers[index].text,
        'type': _selectedTypes[index],
        'quantity': _quantityControllers[index].text,
        'unit': _selectedUnits[index],
        'price': _priceControllers[index].text,
        'calories': _caloriesControllers[index].text,
      };
      _updateFormData();
    }
  }

  bool _isFormValid() {
    for (int i = 0; i < _breadTypes.length; i++) {
      if (_nameControllers[i].text.isEmpty ||
          _selectedTypes[i] == null ||
          _quantityControllers[i].text.isEmpty ||
          _selectedUnits[i] == null ||
          _priceControllers[i].text.isEmpty ||
          _caloriesControllers[i].text.isEmpty) {
        return false;
      }
    }
    return _breadTypes.isNotEmpty;
  }

  void _navigateToOtp() {
    try {
      // Generate a mock verification ID (in real app, this would come from backend)
      const mockVerificationId = 'mock_verification_id_123';

      context.router.push(
        OtpVerificationRoute(
          phoneNumber: widget.phoneNumber,
          verificationId: mockVerificationId,
        ),
      );
    } catch (e) {
      // Handle navigation error gracefully
      debugPrint('Navigation error: $e');
      // You could show a snackbar or dialog here
    }
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
            LocaleKeys.app_bread_type_title.tr(),
            style: AppTextStyles.font20textDarkBrownbold,
          ),
          8.verticalSpace,
          Text(
            LocaleKeys.app_bread_type_instruction.tr(),
            style: AppTextStyles.font15TextW400,
          ),
          32.verticalSpace,

          // Bread Types Individual Containers
          if (_breadTypes.isEmpty) ...[
            // Show empty state or add first bread type
            Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: AppColors.pageBackground,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: AppColors.primaryBurntOrange.withOpacity(0.3),
                  width: 1.5,
                ),
              ),
              child: Center(
                child: Text(
                  'No bread types added yet',
                  style: AppTextStyles.font16TextW500,
                ),
              ),
            ),
          ] else ...[
            ...List.generate(_breadTypes.length, (index) {
              return Container(
                margin: EdgeInsets.only(bottom: 16.h),
                decoration: BoxDecoration(
                  color: AppColors.pageBackground,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: AppColors.primaryBurntOrange.withOpacity(0.3),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  children: [
                    // Header
                    GestureDetector(
                      onTap: () => _toggleExpansion(index),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: 12.h),
                        child: Row(
                          children: [
                            Icon(
                              Icons.bakery_dining_outlined,
                              color: AppColors.primaryBurntOrange,
                              size: 20.sp,
                            ),
                            12.horizontalSpace,
                            Text(
                              '${LocaleKeys.app_bread_type_panel_title.tr()} ${index + 1}',
                              style: AppTextStyles.font16textDarkBrownBold,
                            ),
                            const Spacer(),
                            if (_nameControllers[index].text.isNotEmpty)
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8.w, vertical: 4.h),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryBurntOrange
                                      .withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Text(
                                  _nameControllers[index].text,
                                  style: AppTextStyles.font12PrimaryBurntOrange,
                                ),
                              ),
                            8.horizontalSpace,
                            // Delete button (only show if more than one bread type)
                            if (_breadTypes.length > 1)
                              GestureDetector(
                                onTap: () => _deleteBreadType(index),
                                child: Icon(
                                  Icons.delete_outline,
                                  color: Colors.red,
                                  size: 18.sp,
                                ),
                              ),
                            8.horizontalSpace,
                            // Expand/collapse icon
                            Icon(
                              _isExpanded[index]
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              color: AppColors.primaryBurntOrange,
                              size: 24.sp,
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Body (expandable content)
                    if (_isExpanded[index]) _buildExpansionPanelBody(index),
                  ],
                ),
              );
            }),
          ],

          24.verticalSpace,

          // Add Another Bread Type Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _addBreadType,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primaryBurntOrange,
                side: const BorderSide(color: AppColors.primaryBurntOrange),
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              icon: const Icon(Icons.add, size: 20),
              label: Text(
                LocaleKeys.app_bread_type_add_another.tr(),
                style: AppTextStyles.font16PrimaryBold,
              ),
            ),
          ),

          40.verticalSpace,

          // Submit Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isFormValid() ? _navigateToOtp : null,
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
                LocaleKeys.app_bread_type_submit.tr(),
                style: AppTextStyles.font16TextW500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpansionPanelBody(int index) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        children: [
          // Name Field
          _buildConsistentTextField(
            label: LocaleKeys.app_bread_type_name.tr(),
            hint: LocaleKeys.app_bread_type_name_placeholder.tr(),
            controller: _nameControllers[index],
            icon: Icons.bakery_dining_outlined,
            onChanged: () {
              _updateBreadType(index);
              setState(() {}); // Refresh to update header
            },
          ),
          16.verticalSpace,

          // Type Dropdown
          _buildDropdownField(
            label: LocaleKeys.app_bread_type_type.tr(),
            hint: LocaleKeys.app_bread_type_type_placeholder.tr(),
            value: _selectedTypes[index],
            items: ['نوع 1', 'نوع 2', 'نوع 3', 'نوع 4'],
            onChanged: (value) {
              setState(() {
                _selectedTypes[index] = value;
              });
              _updateBreadType(index);
            },
            icon: Icons.category_outlined,
          ),
          16.verticalSpace,

          // Quantity Field
          _buildConsistentTextField(
            label: LocaleKeys.app_bread_type_quantity.tr(),
            hint: LocaleKeys.app_bread_type_quantity_placeholder.tr(),
            controller: _quantityControllers[index],
            icon: Icons.scale_outlined,
            onChanged: () => _updateBreadType(index),
          ),
          16.verticalSpace,

          // Unit Dropdown
          _buildDropdownField(
            label: LocaleKeys.app_bread_type_unit.tr(),
            hint: LocaleKeys.app_bread_type_unit_placeholder.tr(),
            value: _selectedUnits[index],
            items: ['بالكيلو', 'بالجرام'],
            onChanged: (value) {
              setState(() {
                _selectedUnits[index] = value;
              });
              _updateBreadType(index);
            },
            icon: Icons.straighten_outlined,
          ),
          16.verticalSpace,

          // Price Field
          _buildConsistentTextField(
            label: LocaleKeys.app_bread_type_price.tr(),
            hint: LocaleKeys.app_bread_type_price_placeholder.tr(),
            controller: _priceControllers[index],
            icon: Icons.attach_money_outlined,
            onChanged: () => _updateBreadType(index),
          ),
          16.verticalSpace,

          // Calories Field
          _buildConsistentTextField(
            label: LocaleKeys.app_bread_type_calories.tr(),
            hint: LocaleKeys.app_bread_type_calories_placeholder.tr(),
            controller: _caloriesControllers[index],
            icon: Icons.local_fire_department_outlined,
            onChanged: () => _updateBreadType(index),
          ),
        ],
      ),
    );
  }

  Widget _buildConsistentTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required IconData icon,
    VoidCallback? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.font16textDarkBrownBold,
        ),
        8.verticalSpace,
        Container(
          width: double.infinity,
          height: 56.h,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: AppColors.primaryBurntOrange.withOpacity(0.46),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Icon
              Container(
                margin: EdgeInsets.all(12.w),
                padding: EdgeInsets.all(8.w),
                child: Icon(
                  icon,
                  color: AppColors.primaryBurntOrange,
                  size: 20.sp,
                ),
              ),
              // Text Field
              Expanded(
                child: TextFormField(
                  controller: controller,
                  onChanged: (value) => onChanged?.call(),
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.textDarkBrown,
                    fontWeight: FontWeight.normal,
                  ),
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.primaryBurntOrange.withOpacity(0.46),
                      fontWeight: FontWeight.normal,
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 8.w, vertical: 16.h),
                    isDense: true,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String hint,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.font16textDarkBrownBold,
        ),
        8.verticalSpace,
        Container(
          width: double.infinity,
          height: 56.h,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: AppColors.primaryBurntOrange.withOpacity(0.46),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Icon
              Container(
                margin: EdgeInsets.all(12.w),
                padding: EdgeInsets.all(8.w),
                child: Icon(
                  icon,
                  color: AppColors.primaryBurntOrange,
                  size: 20.sp,
                ),
              ),
              // Dropdown
              Expanded(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: value,
                    hint: Text(
                      hint,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.primaryBurntOrange.withOpacity(0.46),
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.textDarkBrown,
                      fontWeight: FontWeight.normal,
                    ),
                    items: items.map((String item) {
                      return DropdownMenuItem<String>(
                        value: item,
                        child: Text(item),
                      );
                    }).toList(),
                    onChanged: onChanged,
                    isExpanded: true,
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: AppColors.primaryBurntOrange,
                      size: 20.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
