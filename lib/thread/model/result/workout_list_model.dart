import 'package:json_annotation/json_annotation.dart';

part 'workout_list_model.g.dart';

@JsonSerializable()
class WorkoutList {
  @JsonKey(name: "data")
  final List<Workout> data;

  WorkoutList({
    required this.data,
  });

  WorkoutList copyWith({
    List<Workout>? data,
  }) =>
      WorkoutList(
        data: data ?? this.data,
      );

  factory WorkoutList.fromJson(Map<String, dynamic> json) =>
      _$WorkoutListFromJson(json);

  Map<String, dynamic> toJson() => _$WorkoutListToJson(this);
}

@JsonSerializable()
class Workout {
  @JsonKey(name: "workoutScheduleId")
  final int workoutScheduleId;
  @JsonKey(name: "workoutId")
  final int workoutId;
  @JsonKey(name: "seq")
  final int seq;
  @JsonKey(name: "title")
  final String title;
  @JsonKey(name: "subTitle")
  final String subTitle;
  @JsonKey(name: "isComplete")
  final bool isComplete;
  @JsonKey(name: "isRecord")
  final bool isRecord;
  @JsonKey(name: "startDate")
  final DateTime startDate;

  Workout({
    required this.workoutScheduleId,
    required this.workoutId,
    required this.seq,
    required this.title,
    required this.subTitle,
    required this.isComplete,
    required this.isRecord,
    required this.startDate,
  });

  Workout copyWith({
    int? workoutScheduleId,
    int? workoutId,
    int? seq,
    String? title,
    String? subTitle,
    bool? isComplete,
    bool? isRecord,
    DateTime? startDate,
  }) =>
      Workout(
        workoutScheduleId: workoutScheduleId ?? this.workoutScheduleId,
        workoutId: workoutId ?? this.workoutId,
        seq: seq ?? this.seq,
        title: title ?? this.title,
        subTitle: subTitle ?? this.subTitle,
        isComplete: isComplete ?? this.isComplete,
        isRecord: isRecord ?? this.isRecord,
        startDate: startDate ?? this.startDate,
      );

  factory Workout.fromJson(Map<String, dynamic> json) =>
      _$WorkoutFromJson(json);

  Map<String, dynamic> toJson() => _$WorkoutToJson(this);
}

@JsonSerializable()
class WorkoutData {
  final DateTime startDate;
  List<Workout>? workouts;

  WorkoutData({
    required this.startDate,
    this.workouts,
  });

  WorkoutData copyWith({
    DateTime? startDate,
    List<Workout>? workouts,
    bool? selected,
  }) =>
      WorkoutData(
        startDate: startDate ?? this.startDate,
        workouts: workouts ?? this.workouts,
      );

  factory WorkoutData.fromJson(Map<String, dynamic> json) =>
      _$WorkoutDataFromJson(json);

  Map<String, dynamic> toJson() => _$WorkoutDataToJson(this);
}
