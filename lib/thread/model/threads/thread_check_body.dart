import 'package:json_annotation/json_annotation.dart';

part 'thread_check_body.g.dart';

@JsonSerializable()
class ThreadCheckBody {
  @JsonKey(name: "checked")
  bool? checked;
  @JsonKey(name: "commentChecked")
  bool? commentChecked;

  ThreadCheckBody({
    this.checked,
    this.commentChecked,
  });

  ThreadCheckBody copyWith({
    bool? checked,
    bool? commentChecked,
  }) =>
      ThreadCheckBody(
        checked: checked ?? this.checked,
        commentChecked: commentChecked ?? this.commentChecked,
      );

  factory ThreadCheckBody.fromJson(Map<String, dynamic> json) =>
      _$ThreadCheckBodyFromJson(json);

  Map<String, dynamic> toJson() => _$ThreadCheckBodyToJson(this);
}
