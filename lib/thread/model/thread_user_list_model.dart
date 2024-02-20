import 'package:json_annotation/json_annotation.dart';

part 'thread_user_list_model.g.dart';

abstract class ThreadUserListModelBase {}

class ThreadUserListModelError extends ThreadUserListModelBase {
  final String message;

  ThreadUserListModelError({
    required this.message,
  });
}

class ThreadUserListModelLoading extends ThreadUserListModelBase {}

@JsonSerializable()
class ThreadUserListModel extends ThreadUserListModelBase {
  @JsonKey(name: "data")
  final List<ThreadUserModel> data;

  ThreadUserListModel({
    required this.data,
  });

  ThreadUserListModel copyWith({
    List<ThreadUserModel>? data,
  }) =>
      ThreadUserListModel(
        data: data ?? this.data,
      );

  factory ThreadUserListModel.fromJson(Map<String, dynamic> json) =>
      _$ThreadUserListModelFromJson(json);

  Map<String, dynamic> toJson() => _$ThreadUserListModelToJson(this);
}

@JsonSerializable()
class ThreadUserModel {
  @JsonKey(name: "id")
  final int id;
  @JsonKey(name: "nickname")
  final String nickname;
  @JsonKey(name: "gender")
  final String gender;
  @JsonKey(name: "availableTickets")
  final List<AvailableTicket>? availableTickets;
  @JsonKey(
    name: "updatedAt",
    // fromJson: DataUtils.dateTimeToLocal,
  )
  DateTime? updatedAt;
  @JsonKey(name: "isChecked")
  final bool isChecked;

  ThreadUserModel({
    required this.id,
    required this.nickname,
    required this.gender,
    this.availableTickets,
    this.updatedAt,
    required this.isChecked,
  });

  ThreadUserModel copyWith({
    int? id,
    String? nickname,
    String? gender,
    List<AvailableTicket>? availableTickets,
    DateTime? updatedAt,
    bool? isChecked,
  }) =>
      ThreadUserModel(
        id: id ?? this.id,
        nickname: nickname ?? this.nickname,
        gender: gender ?? this.gender,
        availableTickets: availableTickets ?? this.availableTickets,
        updatedAt: updatedAt ?? this.updatedAt,
        isChecked: isChecked ?? this.isChecked,
      );

  factory ThreadUserModel.fromJson(Map<String, dynamic> json) =>
      _$ThreadUserModelFromJson(json);

  Map<String, dynamic> toJson() => _$ThreadUserModelToJson(this);
}

@JsonSerializable()
class AvailableTicket {
  @JsonKey(name: "id")
  final int id;
  @JsonKey(name: "isActive")
  bool? isActive;
  @JsonKey(name: "type")
  final String type;
  @JsonKey(name: "month")
  int? month;
  @JsonKey(name: "expiredAt")
  final DateTime expiredAt;

  AvailableTicket({
    required this.id,
    this.isActive,
    required this.type,
    this.month,
    required this.expiredAt,
  });

  AvailableTicket copyWith({
    int? id,
    bool? isActive,
    String? type,
    int? month,
    DateTime? expiredAt,
  }) =>
      AvailableTicket(
        id: id ?? this.id,
        isActive: isActive ?? this.isActive,
        type: type ?? this.type,
        month: month ?? this.month,
        expiredAt: expiredAt ?? this.expiredAt,
      );

  factory AvailableTicket.fromJson(Map<String, dynamic> json) =>
      _$AvailableTicketFromJson(json);

  Map<String, dynamic> toJson() => _$AvailableTicketToJson(this);
}
