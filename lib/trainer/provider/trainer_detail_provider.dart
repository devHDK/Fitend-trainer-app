import 'package:fitend_trainer_app/trainer/model/trainer_detail_model.dart';
import 'package:fitend_trainer_app/trainer/repository/get_me_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final trainerDetailProvider =
    StateNotifierProvider<TrainerStateNotifier, TrainerDetailModelBase>((ref) {
  final repository = ref.watch(getMeRepositoryProvider);

  return TrainerStateNotifier(repository: repository);
});

class TrainerStateNotifier extends StateNotifier<TrainerDetailModelBase> {
  final GetMeRepository repository;

  TrainerStateNotifier({
    required this.repository,
  }) : super(TrainerDetailModelLoading()) {
    getTrainerDetail();
  }

  Future<void> getTrainerDetail() async {
    try {
      final ret = await repository.getTrainerDetail();

      state = ret;
    } catch (e) {
      state = TrainerDetailModelError(message: '데이터를 불러오지 못했습니다.');
    }
  }
}
