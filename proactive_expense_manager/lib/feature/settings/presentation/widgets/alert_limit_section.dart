import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:proactive_expense_manager/core/di/injection_container.dart';
import 'package:proactive_expense_manager/core/extensions/sized_box_extension.dart';
import 'package:proactive_expense_manager/core/services/local_storage_service.dart';
import 'package:proactive_expense_manager/core/theme/app_colors.dart';
import 'package:proactive_expense_manager/ui/button/custom_button.dart';
import 'package:proactive_expense_manager/ui/section_header/section_header.dart';
import 'package:proactive_expense_manager/ui/text_field/custom_text_field.dart';

class AlertLimitSection extends StatefulWidget {
  const AlertLimitSection({super.key});

  @override
  State<AlertLimitSection> createState() => _AlertLimitSectionState();
}

class _AlertLimitSectionState extends State<AlertLimitSection> {
  final _controller = TextEditingController();
  final _focus = FocusNode();
  late double _currentLimit;

  @override
  void initState() {
    super.initState();
    _currentLimit = sl<LocalStorageService>().getBudgetLimit();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _setLimit() {
    final value = double.tryParse(_controller.text.trim());
    if (value == null || value <= 0) return;
    sl<LocalStorageService>().saveBudgetLimit(value);
    setState(() => _currentLimit = value);
    _controller.clear();
    _focus.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: 'ALERT LIMIT (₹)',
          color: AppColors.textPrimary,
        ),
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                height: 48.h,
                controller: _controller,
                focusNode: _focus,
                hintText: 'Amount ( ₹ )',
                keyboardType: TextInputType.number,
              ),
            ),
            12.wBox,
            CustomButton(text: 'Set', onPressed: _setLimit, width: 72.w),
          ],
        ),
        8.hBox,
        Text(
          'Current Limit: ₹${_currentLimit.toStringAsFixed(0)}',
          style: tt.bodySmall?.copyWith(color: AppColors.textPrimary),
        ),
      ],
    );
  }
}
