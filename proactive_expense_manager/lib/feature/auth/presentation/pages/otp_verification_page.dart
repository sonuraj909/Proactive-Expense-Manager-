import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import 'package:proactive_expense_manager/core/di/injection_container.dart';
import 'package:proactive_expense_manager/core/extensions/sized_box_extension.dart';
import 'package:proactive_expense_manager/core/router/app_routes.dart';
import 'package:proactive_expense_manager/core/theme/app_colors.dart';
import 'package:proactive_expense_manager/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:proactive_expense_manager/feature/auth/presentation/bloc/auth_event.dart';
import 'package:proactive_expense_manager/feature/auth/presentation/bloc/auth_state.dart';
import 'package:proactive_expense_manager/ui/button/custom_button.dart';

String _maskPhone(String phone) {
  if (phone.length <= 8) return phone;
  return '${phone.substring(0, 4)}****${phone.substring(8)}';
}

class OtpVerificationPage extends StatefulWidget {
  final String phoneNumber;
  final String otp;
  final bool userExists;
  final String? token;
  final String? nickname;

  const OtpVerificationPage({
    super.key,
    this.phoneNumber = '',
    this.otp = '',
    this.userExists = false,
    this.token,
    this.nickname,
  });

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final TextEditingController _pinController = TextEditingController();
  final FocusNode _pinFocusNode = FocusNode();
  bool _isPinComplete = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 100), () {
      _pinFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _pinController.dispose();
    _pinFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthBloc>(),
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is OtpVerifiedExistingUser) {
            context.go(AppRoutes.dashboard);
          } else if (state is OtpVerifiedNewUser) {
            context.pushNamed(
              AppRoutes.setupName,
              queryParameters: {'phone': state.phone},
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
          final defaultPinTheme = PinTheme(
            width: 50.w,
            height: 56.h,
            textStyle: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontSize: 22.sp,
              color: AppColors.textPrimary,
            ),
            decoration: BoxDecoration(
              color: AppColors.textPrimary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
          );

          return Scaffold(
            backgroundColor: AppColors.black,
            body: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: 24.w,
                  vertical: 40.h,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      borderRadius: BorderRadius.circular(8.r),
                      child: Container(
                        padding: EdgeInsets.all(10.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(
                            color: AppColors.textPrimary.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          color: AppColors.textPrimary,
                          size: 16.sp,
                        ),
                      ),
                    ),
                    30.hBox,
                    Text(
                      'Verify OTP',
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    12.hBox,
                    Text.rich(
                      TextSpan(
                        text: 'Enter the 6-Digit code sent to ',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 14.sp,
                        ),
                        children: [
                          TextSpan(
                            text: _maskPhone(widget.phoneNumber),
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.copyWith(
                              fontSize: 14.sp,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (widget.otp.isNotEmpty) ...[
                      8.hBox,
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.secondary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Text(
                          'OTP for testing: ${widget.otp}',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: AppColors.secondary),
                        ),
                      ),
                    ],
                    8.hBox,
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: Text(
                        'Change Number',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 15.sp,
                          color: AppColors.infoColor,
                        ),
                      ),
                    ),
                    30.hBox,
                    Center(
                      child: Pinput(
                        length: 6,
                        controller: _pinController,
                        focusNode: _pinFocusNode,
                        defaultPinTheme: defaultPinTheme,
                        preFilledWidget: Center(
                          child: Text(
                            '-',
                            style: Theme.of(
                              context,
                            ).textTheme.headlineMedium?.copyWith(
                              fontSize: 22.sp,
                              color: AppColors.textPrimary.withValues(
                                alpha: 0.3,
                              ),
                            ),
                          ),
                        ),
                        focusedPinTheme: defaultPinTheme.copyWith(
                          decoration: defaultPinTheme.decoration!.copyWith(
                            border: Border.all(color: AppColors.infoColor),
                          ),
                        ),
                        onCompleted: (_) =>
                            setState(() => _isPinComplete = true),
                        onChanged: (value) {
                          if (_isPinComplete && value.length < 6) {
                            setState(() => _isPinComplete = false);
                          }
                        },
                      ),
                    ),
                    16.hBox,
                    CustomButton(
                      text: 'Verify',
                      isLoading: isLoading,
                      onPressed: _isPinComplete && !isLoading
                          ? () {
                              context.read<AuthBloc>().add(
                                VerifyOtpEvent(
                                  enteredOtp: _pinController.text,
                                  expectedOtp: widget.otp,
                                  userExists: widget.userExists,
                                  token: widget.token,
                                  nickname: widget.nickname,
                                ),
                              );
                            }
                          : null,
                    ),
                    24.hBox,
                    Text(
                      'Resend OTP in 32s',
                      style: Theme.of(context).textTheme.bodySmall,
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
