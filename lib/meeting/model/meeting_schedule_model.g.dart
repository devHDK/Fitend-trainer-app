// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meeting_schedule_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MeetingScheduleModel _$MeetingScheduleModelFromJson(
        Map<String, dynamic> json) =>
    MeetingScheduleModel(
      data: (json['data'] as List<dynamic>)
          .map((e) => MeetingSchedule.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MeetingScheduleModelToJson(
        MeetingScheduleModel instance) =>
    <String, dynamic>{
      'data': instance.data,
    };

MeetingSchedule _$MeetingScheduleFromJson(Map<String, dynamic> json) =>
    MeetingSchedule(
      id: json['id'] as int,
      startTime: DataUtils.dateTimeToLocal(json['startTime'] as String),
      endTime: DataUtils.dateTimeToLocal(json['endTime'] as String),
      status: json['status'] as String,
      userNickname: json['userNickname'] as String,
      trainer: TrainerProfile.fromJson(json['trainer'] as Map<String, dynamic>),
      selected: json['selected'] as bool? ?? false,
    );

Map<String, dynamic> _$MeetingScheduleToJson(MeetingSchedule instance) =>
    <String, dynamic>{
      'id': instance.id,
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime.toIso8601String(),
      'status': instance.status,
      'userNickname': instance.userNickname,
      'trainer': instance.trainer,
      'selected': instance.selected,
    };

TrainerProfile _$TrainerProfileFromJson(Map<String, dynamic> json) =>
    TrainerProfile(
      id: json['id'] as int,
      nickname: json['nickname'] as String,
      profileImage: json['profileImage'] as String,
    );

Map<String, dynamic> _$TrainerProfileToJson(TrainerProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nickname': instance.nickname,
      'profileImage': instance.profileImage,
    };
