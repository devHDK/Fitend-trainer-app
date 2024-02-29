import 'package:json_annotation/json_annotation.dart';

part 'thread_push_data.g.dart';

@JsonSerializable()
class ThreadPushData {
  @JsonKey(name: "id")
  String? id;
  @JsonKey(name: "emoji")
  String? emoji;
  @JsonKey(name: "userId")
  String? userId;
  @JsonKey(name: "trainerId")
  String? trainerId;
  @JsonKey(name: "threadId")
  String? threadId;
  @JsonKey(name: "commentId")
  String? commentId;
  @JsonKey(name: "nickname")
  String? nickname;
  @JsonKey(name: "gender")
  String? gender;

  ThreadPushData({
    this.id,
    this.emoji,
    this.userId,
    this.trainerId,
    this.threadId,
    this.commentId,
    this.nickname,
    this.gender,
  });

  ThreadPushData copyWith({
    String? id,
    String? emoji,
    String? userId,
    String? trainerId,
    String? threadId,
    String? commentId,
    String? nickname,
    String? gender,
  }) =>
      ThreadPushData(
        id: id ?? this.id,
        emoji: emoji ?? this.emoji,
        userId: userId ?? this.userId,
        trainerId: trainerId ?? this.trainerId,
        threadId: threadId ?? this.threadId,
        commentId: commentId ?? this.commentId,
        nickname: nickname ?? this.nickname,
        gender: gender ?? this.gender,
      );

  factory ThreadPushData.fromJson(Map<String, dynamic> json) =>
      _$ThreadPushDataFromJson(json);

  Map<String, dynamic> toJson() => _$ThreadPushDataToJson(this);
}
