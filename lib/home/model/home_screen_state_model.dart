import 'package:json_annotation/json_annotation.dart';

part 'home_screen_state_model.g.dart';

@JsonSerializable()
class HomeScreenStateModel {
  @JsonKey(name: "tabIndex")
  int tabIndex;

  HomeScreenStateModel({
    required this.tabIndex,
  });

  HomeScreenStateModel copyWith({
    int? tabIndex,
  }) =>
      HomeScreenStateModel(
        tabIndex: tabIndex ?? this.tabIndex,
      );

  factory HomeScreenStateModel.fromJson(Map<String, dynamic> json) =>
      _$HomeScreenStateModelFromJson(json);

  Map<String, dynamic> toJson() => _$HomeScreenStateModelToJson(this);
}
