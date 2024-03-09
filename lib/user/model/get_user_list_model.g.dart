// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_user_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetUserListModel _$GetUserListModelFromJson(Map<String, dynamic> json) =>
    GetUserListModel(
      search: json['search'] as String?,
      status: json['status'] as String?,
      trainerId: json['trainerId'] as int,
      start: json['start'] as int,
      perPage: json['perPage'] as int,
    );

Map<String, dynamic> _$GetUserListModelToJson(GetUserListModel instance) =>
    <String, dynamic>{
      'search': instance.search,
      'status': instance.status,
      'trainerId': instance.trainerId,
      'start': instance.start,
      'perPage': instance.perPage,
    };
