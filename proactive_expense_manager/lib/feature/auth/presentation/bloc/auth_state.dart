import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class OtpSentState extends AuthState {
  final String otp;
  final bool userExists;
  final String? token;
  final String? nickname;
  final String phone;

  const OtpSentState({
    required this.otp,
    required this.userExists,
    required this.phone,
    this.token,
    this.nickname,
  });

  @override
  List<Object?> get props => [otp, userExists, phone, token, nickname];
}

class OtpVerifiedExistingUser extends AuthState {
  const OtpVerifiedExistingUser();
}

class OtpVerifiedNewUser extends AuthState {
  final String phone;
  const OtpVerifiedNewUser(this.phone);

  @override
  List<Object?> get props => [phone];
}

class AccountCreatedState extends AuthState {
  const AccountCreatedState();
}

class AuthErrorState extends AuthState {
  final String message;
  const AuthErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

class LoggedOutState extends AuthState {
  const LoggedOutState();
}
