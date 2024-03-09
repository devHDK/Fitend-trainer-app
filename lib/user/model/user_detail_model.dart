import 'package:json_annotation/json_annotation.dart';

part 'user_detail_model.g.dart';

abstract class UserDetailModelBase {}

class UserDetailModelLoading extends UserDetailModelBase {}

class UserDetailModelError extends UserDetailModelBase {
  final String message;

  UserDetailModelError({
    required this.message,
  });
}

@JsonSerializable()
class UserDetailModel extends UserDetailModelBase {
  @JsonKey(name: "id")
  final int id;
  @JsonKey(name: "nickname")
  final String nickname;
  @JsonKey(name: "email")
  final String email;
  @JsonKey(name: "phone")
  final String phone;
  @JsonKey(name: "birth")
  final DateTime birth;
  @JsonKey(name: "gender")
  final String gender;
  @JsonKey(name: "height")
  double? height;
  @JsonKey(name: "weight")
  double? weight;
  @JsonKey(name: "memo")
  String? memo;
  @JsonKey(name: "createdAt")
  final DateTime createdAt;
  @JsonKey(name: "isHolding")
  final bool isHolding;
  @JsonKey(name: "tickets")
  Tickets? tickets;
  @JsonKey(name: "workouts")
  final Workouts workouts;
  @JsonKey(name: "trainers")
  List<Trainer>? trainers;
  @JsonKey(name: "preSurvey")
  PreSurvey? preSurvey;

  UserDetailModel({
    required this.id,
    required this.nickname,
    required this.email,
    required this.phone,
    required this.birth,
    required this.gender,
    this.height,
    this.weight,
    this.memo,
    required this.createdAt,
    required this.isHolding,
    this.tickets,
    required this.workouts,
    this.trainers,
    this.preSurvey,
  });

  UserDetailModel copyWith({
    int? id,
    String? nickname,
    String? email,
    String? phone,
    DateTime? birth,
    String? gender,
    double? height,
    double? weight,
    String? memo,
    DateTime? createdAt,
    bool? isHolding,
    Tickets? tickets,
    Workouts? workouts,
    List<Trainer>? trainers,
    PreSurvey? preSurvey,
  }) =>
      UserDetailModel(
        id: id ?? this.id,
        nickname: nickname ?? this.nickname,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        birth: birth ?? this.birth,
        gender: gender ?? this.gender,
        height: height ?? this.height,
        weight: weight ?? this.weight,
        memo: memo ?? this.memo,
        createdAt: createdAt ?? this.createdAt,
        isHolding: isHolding ?? this.isHolding,
        tickets: tickets ?? this.tickets,
        workouts: workouts ?? this.workouts,
        trainers: trainers ?? this.trainers,
        preSurvey: preSurvey ?? this.preSurvey,
      );

  factory UserDetailModel.fromJson(Map<String, dynamic> json) =>
      _$UserDetailModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserDetailModelToJson(this);
}

@JsonSerializable()
class PreSurvey {
  @JsonKey(name: "experience")
  final int experience;
  @JsonKey(name: "purpose")
  final int purpose;
  @JsonKey(name: "achievement")
  final List<int> achievement;
  @JsonKey(name: "obstacle")
  final List<int> obstacle;
  @JsonKey(name: "place")
  final String place;
  @JsonKey(name: "preferDays")
  final List<int> preferDays;

  PreSurvey({
    required this.experience,
    required this.purpose,
    required this.achievement,
    required this.obstacle,
    required this.place,
    required this.preferDays,
  });

  PreSurvey copyWith({
    int? experience,
    int? purpose,
    List<int>? achievement,
    List<int>? obstacle,
    String? place,
    List<int>? preferDays,
  }) =>
      PreSurvey(
        experience: experience ?? this.experience,
        purpose: purpose ?? this.purpose,
        achievement: achievement ?? this.achievement,
        obstacle: obstacle ?? this.obstacle,
        place: place ?? this.place,
        preferDays: preferDays ?? this.preferDays,
      );

  factory PreSurvey.fromJson(Map<String, dynamic> json) =>
      _$PreSurveyFromJson(json);

  Map<String, dynamic> toJson() => _$PreSurveyToJson(this);
}

@JsonSerializable()
class Tickets {
  @JsonKey(name: "personalCount")
  final int personalCount;
  @JsonKey(name: "fitnessCount")
  final int fitnessCount;
  @JsonKey(name: "expiredCount")
  final int expiredCount;

  Tickets({
    required this.personalCount,
    required this.fitnessCount,
    required this.expiredCount,
  });

  Tickets copyWith({
    int? personalCount,
    int? fitnessCount,
    int? expiredCount,
  }) =>
      Tickets(
        personalCount: personalCount ?? this.personalCount,
        fitnessCount: fitnessCount ?? this.fitnessCount,
        expiredCount: expiredCount ?? this.expiredCount,
      );

  factory Tickets.fromJson(Map<String, dynamic> json) =>
      _$TicketsFromJson(json);

  Map<String, dynamic> toJson() => _$TicketsToJson(this);
}

@JsonSerializable()
class Trainer {
  @JsonKey(name: "id")
  final int id;
  @JsonKey(name: "nickname")
  final String nickname;
  @JsonKey(name: "profileImage")
  final String profileImage;

  Trainer({
    required this.id,
    required this.nickname,
    required this.profileImage,
  });

  Trainer copyWith({
    int? id,
    String? nickname,
    String? profileImage,
  }) =>
      Trainer(
        id: id ?? this.id,
        nickname: nickname ?? this.nickname,
        profileImage: profileImage ?? this.profileImage,
      );

  factory Trainer.fromJson(Map<String, dynamic> json) =>
      _$TrainerFromJson(json);

  Map<String, dynamic> toJson() => _$TrainerToJson(this);
}

@JsonSerializable()
class Workouts {
  @JsonKey(name: "thisMonthCount")
  final int thisMonthCount;
  @JsonKey(name: "asOfTodayCount")
  final int asOfTodayCount;
  @JsonKey(name: "doneCount")
  final int doneCount;
  @JsonKey(name: "recentDate")
  final String recentDate;

  Workouts({
    required this.thisMonthCount,
    required this.asOfTodayCount,
    required this.doneCount,
    required this.recentDate,
  });

  Workouts copyWith({
    int? thisMonthCount,
    int? asOfTodayCount,
    int? doneCount,
    String? recentDate,
  }) =>
      Workouts(
        thisMonthCount: thisMonthCount ?? this.thisMonthCount,
        asOfTodayCount: asOfTodayCount ?? this.asOfTodayCount,
        doneCount: doneCount ?? this.doneCount,
        recentDate: recentDate ?? this.recentDate,
      );

  factory Workouts.fromJson(Map<String, dynamic> json) =>
      _$WorkoutsFromJson(json);

  Map<String, dynamic> toJson() => _$WorkoutsToJson(this);
}
