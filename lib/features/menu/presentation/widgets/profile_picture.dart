import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:io';
import 'package:khubzati/core/theme/styles/app_colors.dart';

class ProfilePicture extends StatelessWidget {
  final String? imageUrl;
  final VoidCallback? onTap;
  final bool isEditing;

  const ProfilePicture({
    super.key,
    this.imageUrl,
    this.onTap,
    this.isEditing = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120.w,
        height: 120.h,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.creamColor,
          border: Border.all(
            color: AppColors.textDarkBrown.withOpacity(0.3),
            width: 2.w,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.textDarkBrown.withOpacity(0.1),
              blurRadius: 8.r,
              offset: Offset(0, 4.h),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Profile Image
            imageUrl != null
                ? ClipOval(
                    child: _buildImage(),
                  )
                : _buildPlaceholder(),
            // Edit Overlay
            if (isEditing)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black.withOpacity(0.5),
                  ),
                  child: Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 30.sp,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    if (imageUrl!.startsWith('http')) {
      // Network image
      return Image.network(
        imageUrl!,
        width: 120.w,
        height: 120.h,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
      );
    } else {
      // Local file image
      return Image.file(
        File(imageUrl!),
        width: 120.w,
        height: 120.h,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
      );
    }
  }

  Widget _buildPlaceholder() {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.creamColor,
      ),
      child: Icon(
        Icons.person,
        size: 60.sp,
        color: AppColors.textDarkBrown.withOpacity(0.5),
      ),
    );
  }
}
