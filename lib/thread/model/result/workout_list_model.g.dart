// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WorkoutList _$WorkoutListFromJson(Map<String, dynamic> json) => WorkoutList(
      data: (json['data'] as List<dynamic>)
          .map((e) => Workout.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$WorkoutListToJson(WorkoutList instance) =>
    <String, dynamic>{
      'data': instance.data,
    };

Workout _$WorkoutFromJson(Map<String, dynamic> json) => Workout(
      workoutScheduleId: json['workoutScheduleId'] as int,
      workoutId: json['workoutId'] as int,
      seq: json['seq'] as int,
      title: json['title'] as String,
      subTitle: json['subTitle'] as String,
      isComplete: json['isComplete'] as bool,
      isRecord: json['isRecord'] as bool,
      startDate: DateTime.parse(json['startDate'] as String),
    );

Map<String, dynamic> _$WorkoutToJson(Workout instance) => <String, dynamic>{
      'workoutScheduleId': instance.workoutScheduleId,
      'workoutId': instance.workoutId,
      'seq': instance.seq,
      'title': instance.title,
      'subTitle': instance.subTitle,
      'isComplete': instance.isComplete,
      'isRecord': instance.isRecord,
      'startDate': instance.startDate.toIso8601String(),
    };

WorkoutData _$WorkoutDataFromJson(Map<String, dynamic> json) => WorkoutData(
      startDate: DateTime.parse(json['startDate'] as String),
      workouts: (json['workouts'] as List<dynamic>?)
          ?.map((e) => Workout.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$WorkoutDataToJson(WorkoutData instance) =>
    <String, dynamic>{
      'startDate': instance.startDate.toIso8601String(),
      'workouts': instance.workouts,
    };
