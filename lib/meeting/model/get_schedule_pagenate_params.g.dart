// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_schedule_pagenate_params.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SchedulePagenateParams _$SchedulePagenateParamsFromJson(
        Map<String, dynamic> json) =>
    SchedulePagenateParams(
      userId: json['userId'] as int?,
      trainerId: json['trainerId'] as int?,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
    );

Map<String, dynamic> _$SchedulePagenateParamsToJson(
        SchedulePagenateParams instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'trainerId': instance.trainerId,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
    };
