import 'package:json_annotation/json_annotation.dart';

part 'get_user_list_model.g.dart';

@JsonSerializable()
class GetUserListModel {
  @JsonKey(name: "search")
  String? search;
  @JsonKey(name: "status")
  String? status;
  @JsonKey(name: "trainerId")
  final int trainerId;
  @JsonKey(name: "start")
  final int start;
  @JsonKey(name: "perPage")
  final int perPage;

  GetUserListModel({
    this.search,
    required this.status,
    required this.trainerId,
    required this.start,
    required this.perPage,
  });

  GetUserListModel copyWith({
    String? search,
    String? status,
    int? trainerId,
    int? start,
    int? perPage,
  }) =>
      GetUserListModel(
        search: search ?? this.search,
        status: status ?? this.status,
        trainerId: trainerId ?? this.trainerId,
        start: start ?? this.start,
        perPage: perPage ?? this.perPage,
      );

  factory GetUserListModel.fromJson(Map<String, dynamic> json) =>
      _$GetUserListModelFromJson(json);

  Map<String, dynamic> toJson() => _$GetUserListModelToJson(this);
}
