import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:file_picker/file_picker.dart';

import '../../../../core/theme/styles/app_colors.dart';

class FileUploadWidget extends StatelessWidget {
  final String labelKey;
  final String buttonKey;
  final String? placeHolder;
  final String? selectedFileName;
  final void Function(String filePath, String fileName)? onFileSelected;

  const FileUploadWidget({
    super.key,
    this.placeHolder,
    this.selectedFileName,
    this.onFileSelected,
    required this.labelKey,
    required this.buttonKey,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 358.w,
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Browse button
          // File name text
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.h),
              child: Text(
                selectedFileName ?? labelKey.tr(),
                textAlign: TextAlign.right,
                style: TextStyle(
                  decoration: TextDecoration.none,
                  fontSize: 12.sp,
                  backgroundColor: Colors.white,
                  color: AppColors.primaryBurntOrange.withOpacity(0.46),
                  fontWeight: FontWeight.normal,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          GestureDetector(
            onTap: () async {
              FilePickerResult? result = await FilePicker.platform.pickFiles(
                type: FileType.custom,
                allowedExtensions: ['jpg', 'png', 'jpeg', 'pdf'],
              );
              if (result != null) {
                // Handle the selected file
                final String? filePath = result.files.single.path;
                final String fileName = result.files.single.name;
                print('Selected file: $filePath');

                if (filePath != null && onFileSelected != null) {
                  onFileSelected!(filePath, fileName);
                }
              } else {
                // User canceled the picker
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              decoration: BoxDecoration(
                color: AppColors.primaryBurntOrange,
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Center(
                child: Text(
                  buttonKey.tr(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
