// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserDetailModel _$UserDetailModelFromJson(Map<String, dynamic> json) =>
    UserDetailModel(
      id: json['id'] as int,
      nickname: json['nickname'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      birth: DateTime.parse(json['birth'] as String),
      gender: json['gender'] as String,
      memo: json['memo'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      isHolding: json['isHolding'] as bool,
      tickets: json['tickets'] == null
          ? null
          : Tickets.fromJson(json['tickets'] as Map<String, dynamic>),
      workouts: Workouts.fromJson(json['workouts'] as Map<String, dynamic>),
      trainers: (json['trainers'] as List<dynamic>?)
          ?.map((e) => Trainer.fromJson(e as Map<String, dynamic>))
          .toList(),
      preSurvey: json['preSurvey'] == null
          ? null
          : PreSurvey.fromJson(json['preSurvey'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserDetailModelToJson(UserDetailModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nickname': instance.nickname,
      'email': instance.email,
      'phone': instance.phone,
      'birth': instance.birth.toIso8601String(),
      'gender': instance.gender,
      'memo': instance.memo,
      'createdAt': instance.createdAt.toIso8601String(),
      'isHolding': instance.isHolding,
      'tickets': instance.tickets,
      'workouts': instance.workouts,
      'trainers': instance.trainers,
      'preSurvey': instance.preSurvey,
    };

PreSurvey _$PreSurveyFromJson(Map<String, dynamic> json) => PreSurvey(
      experience: json['experience'] as int,
      purpose: json['purpose'] as int,
      achievement:
          (json['achievement'] as List<dynamic>).map((e) => e as int).toList(),
      obstacle:
          (json['obstacle'] as List<dynamic>).map((e) => e as int).toList(),
      place: json['place'] as String,
      preferDays:
          (json['preferDays'] as List<dynamic>).map((e) => e as int).toList(),
    );

Map<String, dynamic> _$PreSurveyToJson(PreSurvey instance) => <String, dynamic>{
      'experience': instance.experience,
      'purpose': instance.purpose,
      'achievement': instance.achievement,
      'obstacle': instance.obstacle,
      'place': instance.place,
      'preferDays': instance.preferDays,
    };

Tickets _$TicketsFromJson(Map<String, dynamic> json) => Tickets(
      personalCount: json['personalCount'] as int,
      fitnessCount: json['fitnessCount'] as int,
      expiredCount: json['expiredCount'] as int,
    );

Map<String, dynamic> _$TicketsToJson(Tickets instance) => <String, dynamic>{
      'personalCount': instance.personalCount,
      'fitnessCount': instance.fitnessCount,
      'expiredCount': instance.expiredCount,
    };

Trainer _$TrainerFromJson(Map<String, dynamic> json) => Trainer(
      id: json['id'] as int,
      nickname: json['nickname'] as String,
      profileImage: json['profileImage'] as String,
    );

Map<String, dynamic> _$TrainerToJson(Trainer instance) => <String, dynamic>{
      'id': instance.id,
      'nickname': instance.nickname,
      'profileImage': instance.profileImage,
    };

Workouts _$WorkoutsFromJson(Map<String, dynamic> json) => Workouts(
      thisMonthCount: json['thisMonthCount'] as int,
      asOfTodayCount: json['asOfTodayCount'] as int,
      doneCount: json['doneCount'] as int,
      recentDate: json['recentDate'] as String,
    );

Map<String, dynamic> _$WorkoutsToJson(Workouts instance) => <String, dynamic>{
      'thisMonthCount': instance.thisMonthCount,
      'asOfTodayCount': instance.asOfTodayCount,
      'doneCount': instance.doneCount,
      'recentDate': instance.recentDate,
    };
