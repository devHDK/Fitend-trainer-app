import 'package:json_annotation/json_annotation.dart';

part 'get_thread_user_list_params.g.dart';

@JsonSerializable()
class GetThreadUserListParams {
  @JsonKey(name: "search")
  String? search;
  @JsonKey(name: "order")
  final String order;

  GetThreadUserListParams({
    required this.search,
    required this.order,
  });

  GetThreadUserListParams copyWith({
    String? search,
    String? order,
  }) =>
      GetThreadUserListParams(
        search: search ?? this.search,
        order: order ?? this.order,
      );

  factory GetThreadUserListParams.fromJson(Map<String, dynamic> json) =>
      _$GetThreadUserListParamsFromJson(json);

  Map<String, dynamic> toJson() => _$GetThreadUserListParamsToJson(this);
}
