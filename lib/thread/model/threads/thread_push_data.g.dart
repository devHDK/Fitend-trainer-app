// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'thread_push_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ThreadPushData _$ThreadPushDataFromJson(Map<String, dynamic> json) =>
    ThreadPushData(
      id: json['id'] as String?,
      emoji: json['emoji'] as String?,
      userId: json['userId'] as String?,
      trainerId: json['trainerId'] as String?,
      threadId: json['threadId'] as String?,
      commentId: json['commentId'] as String?,
      nickname: json['nickname'] as String?,
      gender: json['gender'] as String?,
    );

Map<String, dynamic> _$ThreadPushDataToJson(ThreadPushData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'emoji': instance.emoji,
      'userId': instance.userId,
      'trainerId': instance.trainerId,
      'threadId': instance.threadId,
      'commentId': instance.commentId,
      'nickname': instance.nickname,
      'gender': instance.gender,
    };
