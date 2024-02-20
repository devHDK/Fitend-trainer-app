import 'package:fitend_trainer_app/common/utils/data_utils.dart';
import 'package:json_annotation/json_annotation.dart';

part 'meeting_schedule_model.g.dart';

@JsonSerializable()
class MeetingScheduleModel {
  @JsonKey(name: "data")
  final List<MeetigSchedule> data;

  MeetingScheduleModel({
    required this.data,
  });

  MeetingScheduleModel copyWith({
    List<MeetigSchedule>? data,
  }) =>
      MeetingScheduleModel(
        data: data ?? this.data,
      );

  factory MeetingScheduleModel.fromJson(Map<String, dynamic> json) =>
      _$MeetingScheduleModelFromJson(json);

  Map<String, dynamic> toJson() => _$MeetingScheduleModelToJson(this);
}

@JsonSerializable()
class MeetigSchedule {
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

  MeetigSchedule({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.userNickname,
    required this.trainer,
    this.selected = false,
  });

  MeetigSchedule copyWith({
    int? id,
    DateTime? startTime,
    DateTime? endTime,
    String? status,
    String? userNickname,
    TrainerProfile? trainer,
    bool? selected,
  }) =>
      MeetigSchedule(
        id: id ?? this.id,
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
        status: status ?? this.status,
        userNickname: userNickname ?? this.userNickname,
        trainer: trainer ?? this.trainer,
        selected: selected ?? this.selected,
      );

  factory MeetigSchedule.fromJson(Map<String, dynamic> json) =>
      _$MeetigScheduleFromJson(json);

  Map<String, dynamic> toJson() => _$MeetigScheduleToJson(this);
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
