// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_thread_user_list_params.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetThreadUserListParams _$GetThreadUserListParamsFromJson(
        Map<String, dynamic> json) =>
    GetThreadUserListParams(
      search: json['search'] as String?,
      order: json['order'] as String,
    );

Map<String, dynamic> _$GetThreadUserListParamsToJson(
        GetThreadUserListParams instance) =>
    <String, dynamic>{
      'search': instance.search,
      'order': instance.order,
    };
