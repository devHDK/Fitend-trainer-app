import 'package:fitend_trainer_app/common/utils/data_utils.dart';
import 'package:json_annotation/json_annotation.dart';

part 'post_meeting_model.g.dart';

@JsonSerializable()
class PostMeetingModel {
  @JsonKey(name: "trainerId")
  final int trainerId;
  @JsonKey(name: "userId")
  int? userId;
  @JsonKey(
    name: "startTime",
    toJson: DataUtils.dateTimeToUTC,
  )
  DateTime? startTime;
  @JsonKey(
    name: "endTime",
    toJson: DataUtils.dateTimeToUTC,
  )
  DateTime? endTime;

  PostMeetingModel({
    required this.trainerId,
    this.userId,
    this.startTime,
    this.endTime,
  });

  PostMeetingModel copyWith({
    int? trainerId,
    int? userId,
    DateTime? startTime,
    DateTime? endTime,
  }) =>
      PostMeetingModel(
        trainerId: trainerId ?? this.trainerId,
        userId: userId ?? this.userId,
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
      );

  factory PostMeetingModel.fromJson(Map<String, dynamic> json) =>
      _$PostMeetingModelFromJson(json);

  Map<String, dynamic> toJson() => _$PostMeetingModelToJson(this);
}
