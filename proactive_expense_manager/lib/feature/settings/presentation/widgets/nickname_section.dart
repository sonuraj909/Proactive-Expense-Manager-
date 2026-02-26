import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:proactive_expense_manager/core/di/injection_container.dart';
import 'package:proactive_expense_manager/core/services/local_storage_service.dart';
import 'package:proactive_expense_manager/core/theme/app_colors.dart';
import 'package:proactive_expense_manager/feature/settings/presentation/widgets/nickname_edit_field.dart';
import 'package:proactive_expense_manager/ui/text_field/custom_text_field.dart';

class NicknameSection extends StatefulWidget {
  const NicknameSection({super.key});

  @override
  State<NicknameSection> createState() => _NicknameSectionState();
}

class _NicknameSectionState extends State<NicknameSection> {
  late final TextEditingController _controller;
  final _focus = FocusNode();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    final saved = sl<LocalStorageService>().getNickname() ?? '';
    _controller = TextEditingController(text: saved);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _startEditing() {
    setState(() => _isEditing = true);
    _focus.requestFocus();
  }

  void _saveNickname() {
    sl<LocalStorageService>().saveNickname(_controller.text.trim());
    setState(() => _isEditing = false);
    _focus.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    if (_isEditing) {
      return NicknameEditField(
        controller: _controller,
        focusNode: _focus,
        onChanged: () => setState(() {}),
        onSave: _saveNickname,
      );
    }

    return CustomTextField(
      height: 64.h,
      controller: _controller,
      focusNode: _focus,
      hintText: 'Nickname',
      readOnly: true,
      backgroundColor: AppColors.surfaceElevated,
      border: Border.all(color: AppColors.border),
      suffixIcon: GestureDetector(
        onTap: _startEditing,
        child: Padding(
          padding: EdgeInsets.only(top: 12.h, bottom: 12.h, right: 12.h),
          child: AspectRatio(
            aspectRatio: 1,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.textPrimary),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                Icons.edit_outlined,
                color: AppColors.textPrimary,
                size: 16.sp,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
