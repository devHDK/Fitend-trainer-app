import 'package:fitend_trainer_app/common/utils/data_utils.dart';
import 'package:json_annotation/json_annotation.dart';

part 'put_meeting_model.g.dart';

@JsonSerializable()
class PutMeetingModel {
  @JsonKey(name: "status")
  String status;
  @JsonKey(
    name: "startTime",
    toJson: DataUtils.dateTimeToUTC,
  )
  DateTime startTime;
  @JsonKey(
    name: "endTime",
    toJson: DataUtils.dateTimeToUTC,
  )
  DateTime endTime;

  PutMeetingModel({
    this.status = 'complete',
    required this.startTime,
    required this.endTime,
  });

  PutMeetingModel copyWith({
    String? status,
    DateTime? startTime,
    DateTime? endTime,
  }) =>
      PutMeetingModel(
        status: status ?? this.status,
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
      );

  factory PutMeetingModel.fromJson(Map<String, dynamic> json) =>
      _$PutMeetingModelFromJson(json);

  Map<String, dynamic> toJson() => _$PutMeetingModelToJson(this);
}
