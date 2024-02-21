// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'thread_get_list_params_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ThreadGetListParamsModel _$ThreadGetListParamsModelFromJson(
        Map<String, dynamic> json) =>
    ThreadGetListParamsModel(
      userId: json['userId'] as int,
      start: json['start'] as int,
      perPage: json['perPage'] as int,
    );

Map<String, dynamic> _$ThreadGetListParamsModelToJson(
        ThreadGetListParamsModel instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'start': instance.start,
      'perPage': instance.perPage,
    };
