import 'package:fitend_trainer_app/thread/model/userlist/thread_user_list_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_list_model.g.dart';

abstract class UserListModelBase {}

class UserListModelLoading extends UserListModelBase {}

class UserListModelError extends UserListModelBase {
  final String message;

  UserListModelError({
    required this.message,
  });
}

@JsonSerializable()
class UserListModel extends UserListModelBase {
  @JsonKey(name: "data")
  final List<UserData> data;
  @JsonKey(name: "total")
  final int total;

  UserListModel({
    required this.data,
    required this.total,
  });

  UserListModel copyWith({
    List<UserData>? data,
    int? total,
  }) =>
      UserListModel(
        data: data ?? this.data,
        total: total ?? this.total,
      );

  factory UserListModel.fromJson(Map<String, dynamic> json) =>
      _$UserListModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserListModelToJson(this);
}

class UserListModelFetchingMore extends UserListModel {
  UserListModelFetchingMore({
    required super.data,
    required super.total,
  });
}

class UserListModelRefetching extends UserListModel {
  UserListModelRefetching({
    required super.data,
    required super.total,
  });
}

@JsonSerializable()
class UserData {
  @JsonKey(name: "id")
  final int id;
  @JsonKey(name: "nickname")
  final String nickname;
  @JsonKey(name: "phone")
  final String phone;
  @JsonKey(name: "gender")
  final String gender;
  @JsonKey(name: "availableTickets")
  final List<AvailableTicket>? availableTickets;
  @JsonKey(name: "trainers")
  final List<Trainer> trainers;
  @JsonKey(name: "createdAt")
  final DateTime createdAt;
  @JsonKey(name: "isHolding")
  final bool isHolding;

  UserData({
    required this.id,
    required this.nickname,
    required this.phone,
    required this.gender,
    this.availableTickets,
    required this.trainers,
    required this.createdAt,
    required this.isHolding,
  });

  UserData copyWith({
    int? id,
    String? nickname,
    String? phone,
    String? gender,
    List<AvailableTicket>? availableTickets,
    List<Trainer>? trainers,
    DateTime? createdAt,
    bool? isHolding,
  }) =>
      UserData(
        id: id ?? this.id,
        nickname: nickname ?? this.nickname,
        phone: phone ?? this.phone,
        gender: gender ?? this.gender,
        availableTickets: availableTickets ?? this.availableTickets,
        trainers: trainers ?? this.trainers,
        createdAt: createdAt ?? this.createdAt,
        isHolding: isHolding ?? this.isHolding,
      );

  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);

  Map<String, dynamic> toJson() => _$UserDataToJson(this);
}

@JsonSerializable()
class Trainer {
  @JsonKey(name: "id")
  final int id;
  @JsonKey(name: "nickname")
  final String nickname;

  Trainer({
    required this.id,
    required this.nickname,
  });

  Trainer copyWith({
    int? id,
    String? nickname,
  }) =>
      Trainer(
        id: id ?? this.id,
        nickname: nickname ?? this.nickname,
      );

  factory Trainer.fromJson(Map<String, dynamic> json) =>
      _$TrainerFromJson(json);

  Map<String, dynamic> toJson() => _$TrainerToJson(this);
}
