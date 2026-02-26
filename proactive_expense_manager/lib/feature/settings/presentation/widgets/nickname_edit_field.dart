import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:proactive_expense_manager/core/extensions/sized_box_extension.dart';
import 'package:proactive_expense_manager/core/theme/app_colors.dart';
import 'package:proactive_expense_manager/ui/button/custom_button.dart';
import 'package:proactive_expense_manager/ui/text_field/custom_text_field.dart';

class NicknameEditField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onSave;
  final VoidCallback onChanged;

  const NicknameEditField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onSave,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          CustomTextField(
            controller: controller,
            focusNode: focusNode,
            hintText: 'Nickname',
            borderRadius: 100.r,
            backgroundColor: AppColors.surfaceVariant,
            onChanged: (_) => onChanged(),
            suffixIcon: controller.text.isNotEmpty
                ? Icon(
                    Icons.check_circle_outline,
                    color: AppColors.successColor,
                    size: 20.sp,
                  )
                : null,
          ),
          12.hBox,
          CustomButton(text: 'Save', onPressed: onSave, borderRadius: 12.r),
        ],
      ),
    );
  }
}
