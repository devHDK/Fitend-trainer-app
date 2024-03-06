// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_meeting_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostMeetingModel _$PostMeetingModelFromJson(Map<String, dynamic> json) =>
    PostMeetingModel(
      trainerId: json['trainerId'] as int,
      userId: json['userId'] as int?,
      startTime: json['startTime'] == null
          ? null
          : DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] == null
          ? null
          : DateTime.parse(json['endTime'] as String),
    );

Map<String, dynamic> _$PostMeetingModelToJson(PostMeetingModel instance) =>
    <String, dynamic>{
      'trainerId': instance.trainerId,
      'userId': instance.userId,
      'startTime': DataUtils.dateTimeToUTC(instance.startTime),
      'endTime': DataUtils.dateTimeToUTC(instance.endTime),
    };
