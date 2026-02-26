import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:proactive_expense_manager/core/theme/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType keyboardType;
  final Function(String)? onChanged;
  final Color? cursorColor;
  final Color? backgroundColor;
  final Border? border;
  final double? height;
  final double? borderRadius;
  final bool readOnly;
  final List<TextInputFormatter>? inputFormatters;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.cursorColor,
    this.backgroundColor,
    this.border,
    this.height,
    this.borderRadius,
    this.readOnly = false,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 56.h,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.inputBackground,
        border: border,
        borderRadius: BorderRadius.circular(borderRadius ?? 8.r),
      ),
      child: Center(
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          keyboardType: keyboardType,
          cursorColor: cursorColor ?? AppColors.textPrimary,
          readOnly: readOnly,
          autocorrect: false,
          textAlignVertical: TextAlignVertical.center,
          inputFormatters: inputFormatters,
          style: Theme.of(context).textTheme.labelMedium,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: Theme.of(
              context,
            ).textTheme.labelMedium?.copyWith(color: AppColors.textTertiary),
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            focusedErrorBorder: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 16.h,
            ),
          ),
        ),
      ),
    );
  }
}
