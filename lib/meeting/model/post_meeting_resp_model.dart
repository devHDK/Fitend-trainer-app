import 'package:json_annotation/json_annotation.dart';

part 'post_meeting_resp_model.g.dart';

@JsonSerializable()
class PostMeetingResp {
  @JsonKey(name: "id")
  final int id;

  PostMeetingResp({
    required this.id,
  });

  PostMeetingResp copyWith({
    int? id,
  }) =>
      PostMeetingResp(
        id: id ?? this.id,
      );

  factory PostMeetingResp.fromJson(Map<String, dynamic> json) =>
      _$PostMeetingRespFromJson(json);

  Map<String, dynamic> toJson() => _$PostMeetingRespToJson(this);
}
