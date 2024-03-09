// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_body_spec_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserBodySpecList _$UserBodySpecListFromJson(Map<String, dynamic> json) =>
    UserBodySpecList(
      data: (json['data'] as List<dynamic>)
          .map((e) => BodySpecModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int,
    );

Map<String, dynamic> _$UserBodySpecListToJson(UserBodySpecList instance) =>
    <String, dynamic>{
      'data': instance.data,
      'total': instance.total,
    };

BodySpecModel _$BodySpecModelFromJson(Map<String, dynamic> json) =>
    BodySpecModel(
      bodySpecId: json['bodySpecId'] as int,
      height: (json['height'] as num).toDouble(),
      weight: (json['weight'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$BodySpecModelToJson(BodySpecModel instance) =>
    <String, dynamic>{
      'bodySpecId': instance.bodySpecId,
      'height': instance.height,
      'weight': instance.weight,
      'createdAt': instance.createdAt.toIso8601String(),
    };
