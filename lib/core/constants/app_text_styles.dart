import 'package:ai_chat/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextStyles {
  // Font Family (optional - set globally if using Google Fonts)
  static const String fontFamily = 'Roboto';

  // ================= HEADINGS =================
  static TextStyle h1 = TextStyle(
    fontSize: 32.sp,
    fontWeight: FontWeight.bold,
    height: 1.3,
    letterSpacing: -0.5,
    fontFamily: fontFamily,
  );

  static TextStyle h2 = TextStyle(
    fontSize: 28.sp,
    fontWeight: FontWeight.w700,
    height: 1.3,
    letterSpacing: -0.3,
    fontFamily: fontFamily,
  );

  static TextStyle h3 = TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.w600,
    height: 1.4,
    fontFamily: fontFamily,
  );

  // ================= BODY =================
  static TextStyle bodyLarge = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w400,
    height: 1.5,
    fontFamily: fontFamily,
  );

  static TextStyle bodyMedium = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    height: 1.5,
    fontFamily: fontFamily,
  );

  static TextStyle bodySmall = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    height: 1.5,
    fontFamily: fontFamily,
    color: AppColors.backgroundDark
  );

  // ================= LABELS =================
  static TextStyle labelLarge = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
    fontFamily: fontFamily,
  );

  static TextStyle labelMedium = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.3,
    fontFamily: fontFamily,
    color: AppColors.dividerDark
  );

  static TextStyle labelSmall = TextStyle(
    fontSize: 10.sp,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.3,
    fontFamily: fontFamily,
  );

  // ================= BUTTON =================
  static TextStyle buttonLarge = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    fontFamily: fontFamily,
  );

  static TextStyle buttonMedium = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    fontFamily: fontFamily,
    color: AppColors.primary
  );

  // ================= CAPTION =================
  static TextStyle caption = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    color: Colors.grey,
    fontFamily: fontFamily,
  );

  // ================= HELPERS =================
  static TextStyle withColor(TextStyle style, Color color) {
    return style.copyWith(color: color);
  }

  static TextStyle semiBold(TextStyle style) {
    return style.copyWith(fontWeight: FontWeight.w600);
  }

  static TextStyle bold(TextStyle style) {
    return style.copyWith(fontWeight: FontWeight.bold);
  }
}

