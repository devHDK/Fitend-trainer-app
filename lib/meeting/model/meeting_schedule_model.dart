import 'package:fitend_trainer_app/common/utils/data_utils.dart';
import 'package:json_annotation/json_annotation.dart';

part 'meeting_schedule_model.g.dart';

@JsonSerializable()
class MeetingScheduleModel {
  @JsonKey(name: "data")
  final List<MeetingSchedule> data;

  MeetingScheduleModel({
    required this.data,
  });

  MeetingScheduleModel copyWith({
    List<MeetingSchedule>? data,
  }) =>
      MeetingScheduleModel(
        data: data ?? this.data,
      );

  factory MeetingScheduleModel.fromJson(Map<String, dynamic> json) =>
      _$MeetingScheduleModelFromJson(json);

  Map<String, dynamic> toJson() => _$MeetingScheduleModelToJson(this);
}

@JsonSerializable()
class MeetingSchedule {
  @JsonKey(name: "id")
  final int id;
  @JsonKey(
    name: "startTime",
    fromJson: DataUtils.dateTimeToLocal,
  )
  final DateTime startTime;
  @JsonKey(
    name: "endTime",
    fromJson: DataUtils.dateTimeToLocal,
  )
  final DateTime endTime;
  @JsonKey(name: "status")
  final String status;
  @JsonKey(name: "userNickname")
  final String userNickname;
  @JsonKey(name: "trainer")
  final TrainerProfile trainer;
  bool? selected;

  MeetingSchedule({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.userNickname,
    required this.trainer,
    this.selected = false,
  });

  MeetingSchedule copyWith({
    int? id,
    DateTime? startTime,
    DateTime? endTime,
    String? status,
    String? userNickname,
    TrainerProfile? trainer,
    bool? selected,
  }) =>
      MeetingSchedule(
        id: id ?? this.id,
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
        status: status ?? this.status,
        userNickname: userNickname ?? this.userNickname,
        trainer: trainer ?? this.trainer,
        selected: selected ?? this.selected,
      );

  factory MeetingSchedule.fromJson(Map<String, dynamic> json) =>
      _$MeetingScheduleFromJson(json);

  Map<String, dynamic> toJson() => _$MeetingScheduleToJson(this);
}

@JsonSerializable()
class TrainerProfile {
  @JsonKey(name: "id")
  final int id;
  @JsonKey(name: "nickname")
  final String nickname;
  @JsonKey(name: "profileImage")
  final String profileImage;

  TrainerProfile({
    required this.id,
    required this.nickname,
    required this.profileImage,
  });

  TrainerProfile copyWith({
    int? id,
    String? nickname,
    String? profileImage,
  }) =>
      TrainerProfile(
        id: id ?? this.id,
        nickname: nickname ?? this.nickname,
        profileImage: profileImage ?? this.profileImage,
      );

  factory TrainerProfile.fromJson(Map<String, dynamic> json) =>
      _$TrainerProfileFromJson(json);

  Map<String, dynamic> toJson() => _$TrainerProfileToJson(this);
}
