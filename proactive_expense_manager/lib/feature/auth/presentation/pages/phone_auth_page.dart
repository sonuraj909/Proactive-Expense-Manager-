import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class PhoneAuthPage extends StatefulWidget {
  const PhoneAuthPage({super.key});

  @override
  State<PhoneAuthPage> createState() => _PhoneAuthPageState();
}

class _PhoneAuthPageState extends State<PhoneAuthPage> {
  final TextEditingController _phoneController = TextEditingController();
  final FocusNode _phoneFocusNode = FocusNode();
  bool _isValidPhone = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 100), () {
      _phoneFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _phoneFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthBloc>(),
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is OtpSentState) {
            context.pushNamed(
              AppRoutes.otpVerification,
              queryParameters: {
                'phoneNumber': _phoneController.text.trim(),
                'otp': state.otp,
                'userExists': state.userExists.toString(),
                if (state.token != null) 'token': state.token!,
                if (state.nickname != null) 'nickname': state.nickname!,
              },
            );
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
            backgroundColor: AppColors.black,
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 60.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Get Started',
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    8.hBox,
                    Text(
                      'Log In Using Phone & OTP',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    30.hBox,
                    CustomTextField(
                      controller: _phoneController,
                      focusNode: _phoneFocusNode,
                      hintText: 'Phone',
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        FilteringTextInputFormatter.deny(RegExp(r'\s')),
                        LengthLimitingTextInputFormatter(10),
                      ],
                      prefixIcon: Padding(
                        padding: EdgeInsets.only(left: 16.w),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '+91',
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            8.wBox,
                            Container(
                              width: 1,
                              height: 20.h,
                              color: AppColors.textSecondary.withValues(
                                alpha: 0.5,
                              ),
                            ),
                            8.wBox,
                          ],
                        ),
                      ),
                      onChanged: (val) {
                        setState(() => _isValidPhone = val.length >= 10);
                      },
                    ),
                    16.hBox,
                    CustomButton(
                      text: 'Continue',
                      isLoading: isLoading,
                      onPressed: _isValidPhone && !isLoading
                          ? () {
                              context.read<AuthBloc>().add(
                                SendOtpEvent(
                                  _phoneController.text.trim(),
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
