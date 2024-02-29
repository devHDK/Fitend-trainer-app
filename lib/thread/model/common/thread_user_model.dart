import 'package:json_annotation/json_annotation.dart';

part 'thread_user_model.g.dart';

@JsonSerializable()
class ThreadUser {
  @JsonKey(name: "id")
  final int id;
  @JsonKey(name: "nickname")
  final String nickname;
  @JsonKey(name: "gender")
  final String gender;

  ThreadUser({
    required this.id,
    required this.nickname,
    required this.gender,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ThreadUser &&
        other.id == id &&
        other.nickname == nickname &&
        other.gender == gender;
  }

  @override
  int get hashCode => id.hashCode ^ nickname.hashCode ^ gender.hashCode;

  ThreadUser copyWith({
    int? id,
    String? nickname,
    String? gender,
  }) =>
      ThreadUser(
        id: id ?? this.id,
        nickname: nickname ?? this.nickname,
        gender: gender ?? this.gender,
      );

  factory ThreadUser.fromJson(Map<String, dynamic> json) =>
      _$ThreadUserFromJson(json);

  Map<String, dynamic> toJson() => _$ThreadUserToJson(this);
}
