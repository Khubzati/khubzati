import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../theme/styles/app_colors.dart';
import '../theme/styles/app_text_style.dart';

class CustomDropDown extends StatelessWidget {
  final String label;
  final String hintText;
  final List<String> items;
  final String? selectedItem;
  final ValueChanged<String?>? onChanged;

  const CustomDropDown({
    super.key,
    required this.label,
    required this.hintText,
    required this.items,
    this.selectedItem,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          value: selectedItem,
          hint: Text(hintText),
          isExpanded: true,
          decoration: InputDecoration(
            label: Text(context.tr(label)),
            labelStyle: AppTextStyles.font20textDarkBrownbold,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide:
                  BorderSide(color: AppColors.textDarkBrown.withOpacity(0.2)),
            ),
          ),
          icon: Icon(
            Icons.arrow_drop_down,
            color: AppColors.textDarkBrown.withOpacity(0.2),
          ),
          onChanged: onChanged,
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
        ),
      ],
    );
  }
}
