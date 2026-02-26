import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

class SendOtpEvent extends AuthEvent {
  final String phone;
  const SendOtpEvent(this.phone);

  @override
  List<Object?> get props => [phone];
}

class VerifyOtpEvent extends AuthEvent {
  final String enteredOtp;
  final String expectedOtp;
  final bool userExists;
  final String? token;
  final String? nickname;

  const VerifyOtpEvent({
    required this.enteredOtp,
    required this.expectedOtp,
    required this.userExists,
    this.token,
    this.nickname,
  });

  @override
  List<Object?> get props => [
    enteredOtp,
    expectedOtp,
    userExists,
    token,
    nickname,
  ];
}

class CreateAccountEvent extends AuthEvent {
  final String phone;
  final String nickname;

  const CreateAccountEvent({required this.phone, required this.nickname});

  @override
  List<Object?> get props => [phone, nickname];
}

class LogoutEvent extends AuthEvent {
  const LogoutEvent();
}
