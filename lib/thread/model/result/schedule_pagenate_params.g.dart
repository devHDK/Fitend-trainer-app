// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_pagenate_params.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WorkoutSchedulePagenateParams _$WorkoutSchedulePagenateParamsFromJson(
        Map<String, dynamic> json) =>
    WorkoutSchedulePagenateParams(
      userId: json['userId'] as int,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
    );

Map<String, dynamic> _$WorkoutSchedulePagenateParamsToJson(
        WorkoutSchedulePagenateParams instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
    };
