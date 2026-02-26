import 'package:json_annotation/json_annotation.dart';

part 'auth_models.g.dart';

// ── Send OTP ──────────────────────────────────────────────────────────────────

@JsonSerializable()
class SendOtpRequestModel {
  final String phone;

  const SendOtpRequestModel({required this.phone});

  factory SendOtpRequestModel.fromJson(Map<String, dynamic> json) =>
      _$SendOtpRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$SendOtpRequestModelToJson(this);
}

@JsonSerializable()
class SendOtpResponseModel {
  final String status;
  final String otp;
  @JsonKey(name: 'user_exists')
  final bool userExists;
  final String? nickname;
  final String? token;

  const SendOtpResponseModel({
    required this.status,
    required this.otp,
    required this.userExists,
    this.nickname,
    this.token,
  });

  factory SendOtpResponseModel.fromJson(Map<String, dynamic> json) =>
      _$SendOtpResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$SendOtpResponseModelToJson(this);
}

// ── Create Account ────────────────────────────────────────────────────────────

@JsonSerializable()
class CreateAccountRequestModel {
  final String phone;
  final String nickname;

  const CreateAccountRequestModel({
    required this.phone,
    required this.nickname,
  });

  factory CreateAccountRequestModel.fromJson(Map<String, dynamic> json) =>
      _$CreateAccountRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$CreateAccountRequestModelToJson(this);
}

@JsonSerializable()
class CreateAccountResponseModel {
  final String status;
  final String token;

  const CreateAccountResponseModel({
    required this.status,
    required this.token,
  });

  factory CreateAccountResponseModel.fromJson(Map<String, dynamic> json) =>
      _$CreateAccountResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$CreateAccountResponseModelToJson(this);
}
