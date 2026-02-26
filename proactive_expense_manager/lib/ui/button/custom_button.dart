import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:proactive_expense_manager/core/extensions/sized_box_extension.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:proactive_expense_manager/core/theme/app_colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double? width;
  final double? height;
  final double? borderRadius;
  final Color? backgroundColor;
  final Color? disabledBackgroundColor;
  final Color textColor;
  final Color? borderColor;
  final Widget? suffixIcon;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.width,
    this.height,
    this.borderRadius,
    this.backgroundColor = AppColors.secondary,
    this.disabledBackgroundColor = AppColors.secondary,
    this.textColor = AppColors.textPrimary,
    this.borderColor,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = onPressed == null && !isLoading;
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 48.h,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          disabledBackgroundColor: disabledBackgroundColor?.withValues(
            alpha: 0.3,
          ),
          disabledForegroundColor: AppColors.textDisabled,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 8.r),
            side: borderColor != null
                ? BorderSide(color: borderColor!)
                : BorderSide.none,
          ),
        ),
        child: isLoading
            ? LoadingAnimationWidget.waveDots(color: textColor, size: 30.sp)
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    text,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: isDisabled ? AppColors.textDisabled : textColor,
                    ),
                  ),
                  if (suffixIcon != null) ...[
                    8.wBox,
                    suffixIcon!,
                  ],
                ],
              ),
      ),
    );
  }
}
