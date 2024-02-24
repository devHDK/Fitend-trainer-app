// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'thread_user_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ThreadUserListModel _$ThreadUserListModelFromJson(Map<String, dynamic> json) =>
    ThreadUserListModel(
      data: (json['data'] as List<dynamic>)
          .map((e) => ThreadUserModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ThreadUserListModelToJson(
        ThreadUserListModel instance) =>
    <String, dynamic>{
      'data': instance.data,
    };

ThreadUserModel _$ThreadUserModelFromJson(Map<String, dynamic> json) =>
    ThreadUserModel(
      id: json['id'] as int,
      nickname: json['nickname'] as String,
      gender: json['gender'] as String,
      availableTickets: (json['availableTickets'] as List<dynamic>?)
          ?.map((e) => AvailableTicket.fromJson(e as Map<String, dynamic>))
          .toList(),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      isChecked: json['isChecked'] as bool,
    );

Map<String, dynamic> _$ThreadUserModelToJson(ThreadUserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nickname': instance.nickname,
      'gender': instance.gender,
      'availableTickets': instance.availableTickets,
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'isChecked': instance.isChecked,
    };

AvailableTicket _$AvailableTicketFromJson(Map<String, dynamic> json) =>
    AvailableTicket(
      id: json['id'] as int,
      isActive: json['isActive'] as bool?,
      type: json['type'] as String,
      month: json['month'] as int?,
      expiredAt: DateTime.parse(json['expiredAt'] as String),
    );

Map<String, dynamic> _$AvailableTicketToJson(AvailableTicket instance) =>
    <String, dynamic>{
      'id': instance.id,
      'isActive': instance.isActive,
      'type': instance.type,
      'month': instance.month,
      'expiredAt': instance.expiredAt.toIso8601String(),
    };
