import 'package:json_annotation/json_annotation.dart';

part 'payroll_model.g.dart';

abstract class PayrollModelBase {}

class PayrollModelLoading extends PayrollModelBase {}

class PayrollModelError extends PayrollModelBase {
  final String message;

  PayrollModelError({
    required this.message,
  });
}

@JsonSerializable()
class PayrollModel extends PayrollModelBase {
  @JsonKey(name: "userCount")
  final UserCount userCount;
  @JsonKey(name: "wageInfo")
  final WageInfo wageInfo;
  @JsonKey(name: "coaching")
  final Coaching coaching;

  PayrollModel({
    required this.userCount,
    required this.wageInfo,
    required this.coaching,
  });

  PayrollModel copyWith({
    UserCount? userCount,
    WageInfo? wageInfo,
    Coaching? coaching,
  }) =>
      PayrollModel(
        userCount: userCount ?? this.userCount,
        wageInfo: wageInfo ?? this.wageInfo,
        coaching: coaching ?? this.coaching,
      );

  factory PayrollModel.fromJson(Map<String, dynamic> json) =>
      _$PayrollModelFromJson(json);

  Map<String, dynamic> toJson() => _$PayrollModelToJson(this);
}

@JsonSerializable()
class Coaching {
  @JsonKey(name: "data")
  final List<CoachingData> data;
  @JsonKey(name: "total")
  final int total;

  Coaching({
    required this.data,
    required this.total,
  });

  Coaching copyWith({
    List<CoachingData>? data,
    int? total,
  }) =>
      Coaching(
        data: data ?? this.data,
        total: total ?? this.total,
      );

  factory Coaching.fromJson(Map<String, dynamic> json) =>
      _$CoachingFromJson(json);

  Map<String, dynamic> toJson() => _$CoachingToJson(this);
}

@JsonSerializable()
class CoachingData {
  @JsonKey(name: "ticketId")
  final int ticketId;
  @JsonKey(name: "nickname")
  final String nickname;
  @JsonKey(name: "type")
  final int type;
  @JsonKey(name: "coachingPrice")
  final int coachingPrice;
  @JsonKey(name: "startedAt")
  final DateTime startedAt;
  @JsonKey(name: "expiredAt")
  final DateTime expiredAt;
  @JsonKey(name: "holdingList")
  final dynamic holdingList;
  @JsonKey(name: "usedDate")
  final int usedDay;
  @JsonKey(name: "payroll")
  final int payroll;

  CoachingData({
    required this.ticketId,
    required this.nickname,
    required this.type,
    required this.coachingPrice,
    required this.startedAt,
    required this.expiredAt,
    required this.holdingList,
    required this.usedDay,
    required this.payroll,
  });

  CoachingData copyWith({
    int? ticketId,
    String? nickname,
    int? type,
    int? coachingPrice,
    DateTime? startedAt,
    DateTime? expiredAt,
    dynamic holdingList,
    int? usedDate,
    int? payroll,
  }) =>
      CoachingData(
        ticketId: ticketId ?? this.ticketId,
        nickname: nickname ?? this.nickname,
        type: type ?? this.type,
        coachingPrice: coachingPrice ?? this.coachingPrice,
        startedAt: startedAt ?? this.startedAt,
        expiredAt: expiredAt ?? this.expiredAt,
        holdingList: holdingList ?? this.holdingList,
        usedDay: usedDate ?? usedDay,
        payroll: payroll ?? this.payroll,
      );

  factory CoachingData.fromJson(Map<String, dynamic> json) =>
      _$CoachingDataFromJson(json);

  Map<String, dynamic> toJson() => _$CoachingDataToJson(this);
}

@JsonSerializable()
class UserCount {
  @JsonKey(name: "preUser")
  final int preUser;
  @JsonKey(name: "paidUser")
  final int paidUser;
  @JsonKey(name: "leaveUser")
  final int leaveUser;

  UserCount({
    required this.preUser,
    required this.paidUser,
    required this.leaveUser,
  });

  UserCount copyWith({
    int? preUser,
    int? paidUser,
    int? leaveUser,
  }) =>
      UserCount(
        preUser: preUser ?? this.preUser,
        paidUser: paidUser ?? this.paidUser,
        leaveUser: leaveUser ?? this.leaveUser,
      );

  factory UserCount.fromJson(Map<String, dynamic> json) =>
      _$UserCountFromJson(json);

  Map<String, dynamic> toJson() => _$UserCountToJson(this);
}

@JsonSerializable()
class WageInfo {
  @JsonKey(name: "wage")
  final int wage;
  @JsonKey(name: "monthEndWage")
  final int monthEndWage;

  WageInfo({
    required this.wage,
    required this.monthEndWage,
  });

  WageInfo copyWith({
    int? wage,
    int? monthEndWage,
  }) =>
      WageInfo(
        wage: wage ?? this.wage,
        monthEndWage: monthEndWage ?? this.monthEndWage,
      );

  factory WageInfo.fromJson(Map<String, dynamic> json) =>
      _$WageInfoFromJson(json);

  Map<String, dynamic> toJson() => _$WageInfoToJson(this);
}
