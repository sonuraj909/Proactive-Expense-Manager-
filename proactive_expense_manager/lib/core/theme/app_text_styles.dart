import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:proactive_expense_manager/core/theme/app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  // Display Styles
  static TextStyle get displayLarge => TextStyle(
    fontSize: 32.sp,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.25,
    color: AppColors.textPrimary,
  );

  static TextStyle get displayMedium => TextStyle(
    fontSize: 28.sp,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.25,
    color: AppColors.textPrimary,
  );

  static TextStyle get displaySmall => TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.5,
    color: AppColors.textPrimary,
  );

  // Headings
  static TextStyle get heading1 => TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.06,
    color: AppColors.textPrimary,
  );

  static TextStyle get heading2 => TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.15,
    color: AppColors.textPrimary,
  );

  static TextStyle get heading3 => TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.45,
    color: AppColors.textSecondary,
  );

  static TextStyle get heading4 => TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.5,
    color: AppColors.textPrimary,
  );

  // Body Text
  static TextStyle get bodyText1 => TextStyle(
    fontSize: 22.sp,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.5,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static TextStyle get bodyText2 => TextStyle(
    fontSize: 15.sp,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.4,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  // Button Text
  static TextStyle get buttonText => TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );

  static TextStyle get buttonTextSmall => TextStyle(
    fontSize: 15.sp,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  );

  // Caption and Labels
  static TextStyle get caption => TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.5,
    color: AppColors.textTertiary,
  );

  static TextStyle get overline => TextStyle(
    fontSize: 13.sp,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.5,
    color: AppColors.textDisabled,
  );
}
