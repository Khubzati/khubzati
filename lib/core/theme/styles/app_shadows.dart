import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppShadows {
  static List<BoxShadow> blur50BlackOP10OffsetDy4 = [
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      blurRadius: 50.r,
      offset: const Offset(0, -4),
    )
  ];

  static List<BoxShadow> blur30BlackOP06ffsetDy12 = [
    BoxShadow(
      color: Colors.black.withOpacity(0.06),
      blurRadius: 30.r,
      offset: const Offset(0, -12),
    )
  ];

  static List<BoxShadow> blur4BlackOP25 = [
    BoxShadow(
      color: Colors.black.withOpacity(0.25),
      blurRadius: 4.r,
    )
  ];
}
