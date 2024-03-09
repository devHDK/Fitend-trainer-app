// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payroll_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PayrollModel _$PayrollModelFromJson(Map<String, dynamic> json) => PayrollModel(
      userCount: UserCount.fromJson(json['userCount'] as Map<String, dynamic>),
      wageInfo: WageInfo.fromJson(json['wageInfo'] as Map<String, dynamic>),
      coaching: Coaching.fromJson(json['coaching'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PayrollModelToJson(PayrollModel instance) =>
    <String, dynamic>{
      'userCount': instance.userCount,
      'wageInfo': instance.wageInfo,
      'coaching': instance.coaching,
    };

Coaching _$CoachingFromJson(Map<String, dynamic> json) => Coaching(
      data: (json['data'] as List<dynamic>)
          .map((e) => CoachingData.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int,
    );

Map<String, dynamic> _$CoachingToJson(Coaching instance) => <String, dynamic>{
      'data': instance.data,
      'total': instance.total,
    };

CoachingData _$CoachingDataFromJson(Map<String, dynamic> json) => CoachingData(
      ticketId: json['ticketId'] as int,
      nickname: json['nickname'] as String,
      type: json['type'] as int,
      coachingPrice: json['coachingPrice'] as int,
      startedAt: DateTime.parse(json['startedAt'] as String),
      expiredAt: DateTime.parse(json['expiredAt'] as String),
      holdingList: json['holdingList'],
      usedDay: json['usedDate'] as int,
      payroll: json['payroll'] as int,
    );

Map<String, dynamic> _$CoachingDataToJson(CoachingData instance) =>
    <String, dynamic>{
      'ticketId': instance.ticketId,
      'nickname': instance.nickname,
      'type': instance.type,
      'coachingPrice': instance.coachingPrice,
      'startedAt': instance.startedAt.toIso8601String(),
      'expiredAt': instance.expiredAt.toIso8601String(),
      'holdingList': instance.holdingList,
      'usedDate': instance.usedDay,
      'payroll': instance.payroll,
    };

UserCount _$UserCountFromJson(Map<String, dynamic> json) => UserCount(
      preUser: json['preUser'] as int,
      paidUser: json['paidUser'] as int,
      leaveUser: json['leaveUser'] as int,
    );

Map<String, dynamic> _$UserCountToJson(UserCount instance) => <String, dynamic>{
      'preUser': instance.preUser,
      'paidUser': instance.paidUser,
      'leaveUser': instance.leaveUser,
    };

WageInfo _$WageInfoFromJson(Map<String, dynamic> json) => WageInfo(
      wage: json['wage'] as int,
      monthEndWage: json['monthEndWage'] as int,
    );

Map<String, dynamic> _$WageInfoToJson(WageInfo instance) => <String, dynamic>{
      'wage': instance.wage,
      'monthEndWage': instance.monthEndWage,
    };
