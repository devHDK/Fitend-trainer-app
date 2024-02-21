import 'package:fitend_trainer_app/thread/model/common/thread_user_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'thread_family_model.g.dart';

@JsonSerializable()
class ThreadFamilyModel {
  @JsonKey(name: "threadId")
  final int threadId;
  @JsonKey(name: "user")
  final ThreadUser user;

  ThreadFamilyModel({
    required this.threadId,
    required this.user,
  });

  ThreadFamilyModel copyWith({
    int? threadId,
    ThreadUser? user,
  }) =>
      ThreadFamilyModel(
        threadId: threadId ?? this.threadId,
        user: user ?? this.user,
      );

  factory ThreadFamilyModel.fromJson(Map<String, dynamic> json) =>
      _$ThreadFamilyModelFromJson(json);

  Map<String, dynamic> toJson() => _$ThreadFamilyModelToJson(this);
}
