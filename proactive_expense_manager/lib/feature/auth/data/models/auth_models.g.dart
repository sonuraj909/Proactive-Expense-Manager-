// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SendOtpRequestModel _$SendOtpRequestModelFromJson(Map<String, dynamic> json) =>
    SendOtpRequestModel(phone: json['phone'] as String);

Map<String, dynamic> _$SendOtpRequestModelToJson(
  SendOtpRequestModel instance,
) => <String, dynamic>{'phone': instance.phone};

SendOtpResponseModel _$SendOtpResponseModelFromJson(
  Map<String, dynamic> json,
) => SendOtpResponseModel(
  status: json['status'] as String,
  otp: json['otp'] as String,
  userExists: json['user_exists'] as bool,
  nickname: json['nickname'] as String?,
  token: json['token'] as String?,
);

Map<String, dynamic> _$SendOtpResponseModelToJson(
  SendOtpResponseModel instance,
) => <String, dynamic>{
  'status': instance.status,
  'otp': instance.otp,
  'user_exists': instance.userExists,
  'nickname': instance.nickname,
  'token': instance.token,
};

CreateAccountRequestModel _$CreateAccountRequestModelFromJson(
  Map<String, dynamic> json,
) => CreateAccountRequestModel(
  phone: json['phone'] as String,
  nickname: json['nickname'] as String,
);

Map<String, dynamic> _$CreateAccountRequestModelToJson(
  CreateAccountRequestModel instance,
) => <String, dynamic>{'phone': instance.phone, 'nickname': instance.nickname};

CreateAccountResponseModel _$CreateAccountResponseModelFromJson(
  Map<String, dynamic> json,
) => CreateAccountResponseModel(
  status: json['status'] as String,
  token: json['token'] as String,
);

Map<String, dynamic> _$CreateAccountResponseModelToJson(
  CreateAccountResponseModel instance,
) => <String, dynamic>{'status': instance.status, 'token': instance.token};
