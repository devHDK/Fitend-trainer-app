// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'put_meeting_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PutMeetingModel _$PutMeetingModelFromJson(Map<String, dynamic> json) =>
    PutMeetingModel(
      status: json['status'] as String? ?? 'complete',
      startTime: json['startTime'] == null
          ? null
          : DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] == null
          ? null
          : DateTime.parse(json['endTime'] as String),
    );

Map<String, dynamic> _$PutMeetingModelToJson(PutMeetingModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'startTime': instance.startTime?.toIso8601String(),
      'endTime': instance.endTime?.toIso8601String(),
    };
