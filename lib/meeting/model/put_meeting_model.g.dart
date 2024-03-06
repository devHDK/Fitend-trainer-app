// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'put_meeting_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PutMeetingModel _$PutMeetingModelFromJson(Map<String, dynamic> json) =>
    PutMeetingModel(
      status: json['status'] as String? ?? 'complete',
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
    );

Map<String, dynamic> _$PutMeetingModelToJson(PutMeetingModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'startTime': DataUtils.dateTimeToUTC(instance.startTime),
      'endTime': DataUtils.dateTimeToUTC(instance.endTime),
    };
