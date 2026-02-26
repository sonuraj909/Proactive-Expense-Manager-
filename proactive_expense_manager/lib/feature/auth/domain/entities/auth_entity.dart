import 'package:equatable/equatable.dart';

class OtpResponseEntity extends Equatable {
  final String otp;
  final bool userExists;
  final String? nickname;
  final String? token;

  const OtpResponseEntity({
    required this.otp,
    required this.userExists,
    this.nickname,
    this.token,
  });

  @override
  List<Object?> get props => [otp, userExists, nickname, token];
}
