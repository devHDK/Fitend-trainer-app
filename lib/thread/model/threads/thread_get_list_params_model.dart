import 'package:json_annotation/json_annotation.dart';

part 'thread_get_list_params_model.g.dart';

@JsonSerializable()
class ThreadGetListParamsModel {
  @JsonKey(name: "userId")
  final int userId;
  @JsonKey(name: "start")
  final int start;
  @JsonKey(name: "perPage")
  final int perPage;

  ThreadGetListParamsModel({
    required this.userId,
    required this.start,
    required this.perPage,
  });

  ThreadGetListParamsModel copyWith({
    int? userId,
    int? start,
    int? perpage,
  }) =>
      ThreadGetListParamsModel(
        userId: userId ?? this.userId,
        start: start ?? this.start,
        perPage: perpage ?? perPage,
      );

  factory ThreadGetListParamsModel.fromJson(Map<String, dynamic> json) =>
      _$ThreadGetListParamsModelFromJson(json);

  Map<String, dynamic> toJson() => _$ThreadGetListParamsModelToJson(this);
}
