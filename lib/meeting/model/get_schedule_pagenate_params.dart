import 'package:json_annotation/json_annotation.dart';

part 'get_schedule_pagenate_params.g.dart';

@JsonSerializable()
class SchedulePagenateParams {
  int? userId;
  int? trainerId;
  final DateTime startDate;
  final DateTime endDate;

  SchedulePagenateParams({
    this.userId,
    this.trainerId,
    required this.startDate,
    required this.endDate,
  });

  SchedulePagenateParams copyWith({
    int? userId,
    int? trainerId,
    DateTime? startDate,
    DateTime? endDate,
  }) =>
      SchedulePagenateParams(
        userId: userId ?? this.userId,
        trainerId: trainerId ?? this.trainerId,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
      );

  factory SchedulePagenateParams.fromJson(Map<String, dynamic> json) =>
      _$SchedulePagenateParamsFromJson(json);

  Map<String, dynamic> toJson() => _$SchedulePagenateParamsToJson(this);
}
