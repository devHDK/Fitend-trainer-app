import 'package:json_annotation/json_annotation.dart';

part 'trainer_model.g.dart';

abstract class TrainerModelBase {}

class TrainerModelError extends TrainerModelBase {
  final String error;
  final int statusCode;

  TrainerModelError({
    required this.error,
    required this.statusCode,
  });
}

class TrainerModelLoading extends TrainerModelBase {}

@JsonSerializable()
class TrainerModel extends TrainerModelBase {
  @JsonKey(name: "trainer")
  final Trainer trainer;

  TrainerModel({
    required this.trainer,
  });

  TrainerModel copyWith({
    Trainer? trainer,
  }) =>
      TrainerModel(
        trainer: trainer ?? this.trainer,
      );

  factory TrainerModel.fromJson(Map<String, dynamic> json) =>
      _$TrainerModelFromJson(json);

  Map<String, dynamic> toJson() => _$TrainerModelToJson(this);
}

@JsonSerializable()
class Trainer {
  @JsonKey(name: "id")
  final int id;
  @JsonKey(name: "email")
  final String email;
  @JsonKey(name: "nickname")
  final String nickname;
  @JsonKey(name: "profileImage")
  final String profileImage;
  @JsonKey(name: "createdAt")
  final String createdAt;

  Trainer({
    required this.id,
    required this.email,
    required this.nickname,
    required this.profileImage,
    required this.createdAt,
  });

  Trainer copyWith({
    int? id,
    String? email,
    String? nickname,
    String? profileImage,
    String? createdAt,
  }) =>
      Trainer(
        id: id ?? this.id,
        email: email ?? this.email,
        nickname: nickname ?? this.nickname,
        profileImage: profileImage ?? this.profileImage,
        createdAt: createdAt ?? this.createdAt,
      );

  factory Trainer.fromJson(Map<String, dynamic> json) =>
      _$TrainerFromJson(json);

  Map<String, dynamic> toJson() => _$TrainerToJson(this);
}
