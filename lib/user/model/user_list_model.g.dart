// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserListModel _$UserListModelFromJson(Map<String, dynamic> json) =>
    UserListModel(
      data: (json['data'] as List<dynamic>)
          .map((e) => UserData.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int,
    );

Map<String, dynamic> _$UserListModelToJson(UserListModel instance) =>
    <String, dynamic>{
      'data': instance.data,
      'total': instance.total,
    };

UserData _$UserDataFromJson(Map<String, dynamic> json) => UserData(
      id: json['id'] as int,
      nickname: json['nickname'] as String,
      phone: json['phone'] as String,
      gender: json['gender'] as String,
      availableTickets: (json['availableTickets'] as List<dynamic>?)
          ?.map((e) => AvailableTicket.fromJson(e as Map<String, dynamic>))
          .toList(),
      trainers: (json['trainers'] as List<dynamic>)
          .map((e) => Trainer.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      isHolding: json['isHolding'] as bool,
    );

Map<String, dynamic> _$UserDataToJson(UserData instance) => <String, dynamic>{
      'id': instance.id,
      'nickname': instance.nickname,
      'phone': instance.phone,
      'gender': instance.gender,
      'availableTickets': instance.availableTickets,
      'trainers': instance.trainers,
      'createdAt': instance.createdAt.toIso8601String(),
      'isHolding': instance.isHolding,
    };

Trainer _$TrainerFromJson(Map<String, dynamic> json) => Trainer(
      id: json['id'] as int,
      nickname: json['nickname'] as String,
    );

Map<String, dynamic> _$TrainerToJson(Trainer instance) => <String, dynamic>{
      'id': instance.id,
      'nickname': instance.nickname,
    };
