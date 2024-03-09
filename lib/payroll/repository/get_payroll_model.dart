import 'package:json_annotation/json_annotation.dart';

part 'get_payroll_model.g.dart';

@JsonSerializable()
class GetPayrollModel {
  @JsonKey(name: "startDate")
  final String startDate;

  GetPayrollModel({
    required this.startDate,
  });

  GetPayrollModel copyWith({
    String? startDate,
  }) =>
      GetPayrollModel(
        startDate: startDate ?? this.startDate,
      );

  factory GetPayrollModel.fromJson(Map<String, dynamic> json) =>
      _$GetPayrollModelFromJson(json);

  Map<String, dynamic> toJson() => _$GetPayrollModelToJson(this);
}
