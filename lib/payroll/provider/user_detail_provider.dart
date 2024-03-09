import 'package:fitend_trainer_app/payroll/model/payroll_model.dart';
import 'package:fitend_trainer_app/payroll/repository/get_payroll_model.dart';
import 'package:fitend_trainer_app/payroll/repository/payroll_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final payrollProvider =
    StateNotifierProviderFamily<PayrollStateNotifier, PayrollModelBase, String>(
        (ref, startDate) {
  final repository = ref.watch(payrollRepositoryProvider);

  return PayrollStateNotifier(
    repository: repository,
    startDate: startDate,
  );
});

class PayrollStateNotifier extends StateNotifier<PayrollModelBase> {
  final PayrollRepository repository;
  final String startDate;

  PayrollStateNotifier({
    required this.repository,
    required this.startDate,
  }) : super(PayrollModelLoading()) {
    init();
  }

  Future<void> init() async {
    try {
      final ret = await repository.getPayroll(
          model: GetPayrollModel(startDate: startDate));

      state = ret;
    } catch (e) {
      state = PayrollModelError(message: '$e');
    }
  }
}
