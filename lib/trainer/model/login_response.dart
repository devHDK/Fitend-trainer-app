import 'package:fitend_trainer_app/trainer/model/trainer_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'login_response.g.dart';

@JsonSerializable()
class LoginResponse {
  final String refreshToken;
  final String accessToken;
  final Trainer trainer;

  LoginResponse({
    required this.refreshToken,
    required this.accessToken,
    required this.trainer,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}
