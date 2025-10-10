import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/styles/app_text_style.dart';
import 'file_upload_widget.dart';

class LabeledFileUpload extends StatelessWidget {
  final String labelKey; // Locale key (not translated)
  final String buttonKey; // Locale key (not translated)
  final String? placeHolder; // Locale key (not translated)
  final String? selectedFileName;
  final void Function(String filePath, String fileName)? onFileSelected;

  const LabeledFileUpload({
    super.key,
    required this.labelKey,
    required this.buttonKey,
    this.placeHolder,
    this.selectedFileName,
    this.onFileSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelKey.tr(),
          style: AppTextStyles.font16textDarkBrownBold,
        ),
        8.verticalSpace,
        FileUploadWidget(
          labelKey: labelKey,
          buttonKey: buttonKey,
          placeHolder: placeHolder?.tr(),
          selectedFileName: selectedFileName,
          onFileSelected: onFileSelected,
        ),
      ],
    );
  }
}
