import 'package:json_annotation/json_annotation.dart';

part 'schedule_pagenate_params.g.dart';

@JsonSerializable()
class WorkoutSchedulePagenateParams {
  final int userId;
  final DateTime startDate;
  final DateTime endDate;

  WorkoutSchedulePagenateParams({
    required this.userId,
    required this.startDate,
    required this.endDate,
  });

  WorkoutSchedulePagenateParams copyWith({
    int? userId,
    DateTime? startDate,
    DateTime? endDate,
  }) =>
      WorkoutSchedulePagenateParams(
        userId: userId ?? this.userId,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
      );

  factory WorkoutSchedulePagenateParams.fromJson(Map<String, dynamic> json) =>
      _$WorkoutSchedulePagenateParamsFromJson(json);

  Map<String, dynamic> toJson() => _$WorkoutSchedulePagenateParamsToJson(this);
}
