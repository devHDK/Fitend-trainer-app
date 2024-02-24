// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'thread_family_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ThreadFamilyModel _$ThreadFamilyModelFromJson(Map<String, dynamic> json) =>
    ThreadFamilyModel(
      threadId: json['threadId'] as int,
      user: ThreadUser.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ThreadFamilyModelToJson(ThreadFamilyModel instance) =>
    <String, dynamic>{
      'threadId': instance.threadId,
      'user': instance.user,
    };
