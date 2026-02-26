import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:proactive_expense_manager/core/di/injection_container.dart';
import 'package:proactive_expense_manager/core/extensions/sized_box_extension.dart';
import 'package:proactive_expense_manager/core/router/app_routes.dart';
import 'package:proactive_expense_manager/core/theme/app_colors.dart';
import 'package:proactive_expense_manager/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:proactive_expense_manager/feature/auth/presentation/bloc/auth_event.dart';
import 'package:proactive_expense_manager/feature/auth/presentation/bloc/auth_state.dart';
import 'package:proactive_expense_manager/ui/button/custom_button.dart';
import 'package:proactive_expense_manager/ui/text_field/custom_text_field.dart';

class SetupNamePage extends StatefulWidget {
  final String phone;
  const SetupNamePage({super.key, this.phone = ''});

  @override
  State<SetupNamePage> createState() => _SetupNamePageState();
}

class _SetupNamePageState extends State<SetupNamePage> {
  final TextEditingController _nameController = TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();
  bool _isValidName = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 100), () {
      _nameFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthBloc>(),
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AccountCreatedState) {
            context.go(AppRoutes.dashboard);
          } else if (state is AuthErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.errorColor,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;
          return Scaffold(
            backgroundColor: AppColors.primary,
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 60.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '👋 What should we call you?',
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    12.hBox,
                    Text(
                      'This name stays only on your device.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 14.sp,
                      ),
                    ),
                    32.hBox,
                    CustomTextField(
                      controller: _nameController,
                      focusNode: _nameFocusNode,
                      hintText: 'Eg: Johnnnie',
                      keyboardType: TextInputType.name,
                      suffixIcon: _isValidName
                          ? Icon(
                              Icons.check_circle_outline,
                              color: AppColors.successColor,
                              size: 16.sp,
                            )
                          : null,
                      onChanged: (val) {
                        setState(() {
                          _isValidName = val.trim().length >= 2;
                        });
                      },
                    ),
                    16.hBox,
                    CustomButton(
                      text: 'Continue',
                      isLoading: isLoading,
                      onPressed: _isValidName && !isLoading
                          ? () {
                              context.read<AuthBloc>().add(
                                CreateAccountEvent(
                                  phone: widget.phone,
                                  nickname: _nameController.text.trim(),
                                ),
                              );
                            }
                          : null,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
