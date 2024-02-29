// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trainer_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TrainerModel _$TrainerModelFromJson(Map<String, dynamic> json) => TrainerModel(
      trainer: Trainer.fromJson(json['trainer'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TrainerModelToJson(TrainerModel instance) =>
    <String, dynamic>{
      'trainer': instance.trainer,
    };

Trainer _$TrainerFromJson(Map<String, dynamic> json) => Trainer(
      id: json['id'] as int,
      email: json['email'] as String,
      nickname: json['nickname'] as String,
      profileImage: json['profileImage'] as String,
      createdAt: json['createdAt'] as String,
      meetingLink: json['meetingLink'] as String,
      isNotification: json['isNotification'] as bool,
    );

Map<String, dynamic> _$TrainerToJson(Trainer instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'nickname': instance.nickname,
      'profileImage': instance.profileImage,
      'createdAt': instance.createdAt,
      'meetingLink': instance.meetingLink,
      'isNotification': instance.isNotification,
    };
