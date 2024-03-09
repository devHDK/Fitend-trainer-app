import 'package:dio/dio.dart' hide Headers;
import 'package:fitend_trainer_app/common/dio/dio.dart';
import 'package:fitend_trainer_app/payroll/model/payroll_model.dart';
import 'package:fitend_trainer_app/payroll/repository/get_payroll_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/retrofit.dart';

part 'payroll_repository.g.dart';

final payrollRepositoryProvider = Provider<PayrollRepository>((ref) {
  final dio = ref.watch(dioProvider);

  return PayrollRepository(dio);
});

@RestApi()
abstract class PayrollRepository {
  factory PayrollRepository(Dio dio) = _PayrollRepository;

  @GET('/payroll/calculated')
  @Headers({
    'accessToken': 'true',
  })
  Future<PayrollModel> getPayroll({
    @Queries() required GetPayrollModel model,
  });
}
