import 'package:json_annotation/json_annotation.dart';

part 'get_pagenate_model.g.dart';

@JsonSerializable()
class GetPagenateModel {
  @JsonKey(name: "start")
  int start;
  @JsonKey(name: "perPage")
  int perPage;

  GetPagenateModel({
    required this.start,
    required this.perPage,
  });

  GetPagenateModel copyWith({
    int? start,
    int? perPage,
  }) =>
      GetPagenateModel(
        start: start ?? this.start,
        perPage: perPage ?? this.perPage,
      );

  factory GetPagenateModel.fromJson(Map<String, dynamic> json) =>
      _$GetPagenateModelFromJson(json);

  Map<String, dynamic> toJson() => _$GetPagenateModelToJson(this);
}
