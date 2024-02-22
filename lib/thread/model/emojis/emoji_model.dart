import 'package:json_annotation/json_annotation.dart';

part 'emoji_model.g.dart';

@JsonSerializable()
class EmojiModel {
  @JsonKey(name: "id")
  final int id;
  @JsonKey(name: "emoji")
  final String emoji;
  @JsonKey(name: "userId")
  int? userId;
  @JsonKey(name: "trainerId")
  int? trainerId;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is EmojiModel &&
        other.id == id &&
        other.emoji == emoji &&
        (other.userId == userId || other.trainerId == trainerId);
  }

  @override
  int get hashCode =>
      id.hashCode ^ emoji.hashCode ^ userId.hashCode ^ trainerId.hashCode;

  EmojiModel({
    required this.id,
    required this.emoji,
    required this.userId,
    required this.trainerId,
  });

  EmojiModel copyWith({
    int? id,
    String? emoji,
    int? userId,
    int? trainerId,
  }) =>
      EmojiModel(
        id: id ?? this.id,
        emoji: emoji ?? this.emoji,
        userId: userId ?? this.userId,
        trainerId: trainerId ?? this.trainerId,
      );

  factory EmojiModel.fromJson(Map<String, dynamic> json) =>
      _$EmojiModelFromJson(json);

  Map<String, dynamic> toJson() => _$EmojiModelToJson(this);
}
