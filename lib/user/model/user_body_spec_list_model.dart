import 'package:json_annotation/json_annotation.dart';

part 'user_body_spec_list_model.g.dart';

@JsonSerializable()
class UserBodySpecList {
  @JsonKey(name: "data")
  final List<BodySpecModel> data;
  @JsonKey(name: "total")
  final int total;

  UserBodySpecList({
    required this.data,
    required this.total,
  });

  UserBodySpecList copyWith({
    List<BodySpecModel>? data,
    int? total,
  }) =>
      UserBodySpecList(
        data: data ?? this.data,
        total: total ?? this.total,
      );

  factory UserBodySpecList.fromJson(Map<String, dynamic> json) =>
      _$UserBodySpecListFromJson(json);

  Map<String, dynamic> toJson() => _$UserBodySpecListToJson(this);
}

@JsonSerializable()
class BodySpecModel {
  @JsonKey(name: "bodySpecId")
  final int bodySpecId;
  @JsonKey(name: "height")
  final double height;
  @JsonKey(name: "weight")
  final double weight;
  @JsonKey(name: "createdAt")
  final DateTime createdAt;

  BodySpecModel({
    required this.bodySpecId,
    required this.height,
    required this.weight,
    required this.createdAt,
  });

  BodySpecModel copyWith({
    int? bodySpecId,
    double? height,
    double? weight,
    DateTime? createdAt,
  }) =>
      BodySpecModel(
        bodySpecId: bodySpecId ?? this.bodySpecId,
        height: height ?? this.height,
        weight: weight ?? this.weight,
        createdAt: createdAt ?? this.createdAt,
      );

  factory BodySpecModel.fromJson(Map<String, dynamic> json) =>
      _$BodySpecModelFromJson(json);

  Map<String, dynamic> toJson() => _$BodySpecModelToJson(this);
}
