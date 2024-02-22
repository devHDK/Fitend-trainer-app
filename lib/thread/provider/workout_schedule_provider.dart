import 'package:fitend_trainer_app/common/utils/data_utils.dart';
import 'package:fitend_trainer_app/thread/model/result/schedule_pagenate_params.dart';
import 'package:fitend_trainer_app/thread/model/result/workout_list_model.dart';
import 'package:fitend_trainer_app/thread/model/result/workout_result_model.dart';
import 'package:fitend_trainer_app/thread/repository/workout_schedule_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' as intl;

final workoutScheduleProvider = StateNotifierProvider.family<
    ScheduleStateNotifier, WorkoutResultModelBase, int>((ref, id) {
  final workoutRepository = ref.watch(workoutScheduleRepositoryProvider);

  return ScheduleStateNotifier(
    id: id,
    workoutRepository: workoutRepository,
  );
});

class ScheduleStateNotifier extends StateNotifier<WorkoutResultModelBase> {
  final int id;
  final WorkoutScheduleRepository workoutRepository;

  ScheduleStateNotifier({
    required this.id,
    required this.workoutRepository,
  }) : super(WorkoutResultModelLoading()) {
    getWorkoutResult();
  }

  Future<void> getWorkoutResult() async {
    try {
      // state = WorkoutResultModelLoading();

      final ret = await workoutRepository.getWorkout(workoutScheduleId: id);

      final lastMondayDate = DataUtils.getLastMondayDate(ret.startDate);

      final scheduleResp = await workoutRepository.getWorkoutSchedules(
          params: WorkoutSchedulePagenateParams(
        userId: ret.userId,
        startDate: lastMondayDate,
        endDate: lastMondayDate.add(const Duration(days: 13)),
      ));

      List<WorkoutData> tempScheduleList = List.generate(
        14,
        (index) => WorkoutData(
          startDate: lastMondayDate.add(Duration(days: index)),
          workouts: [],
        ),
      );

      if (scheduleResp.data.isNotEmpty) {
        for (var tempSchedule in tempScheduleList) {
          for (var workout in scheduleResp.data) {
            if (tempSchedule.startDate.isAtSameMomentAs(workout.startDate)) {
              tempSchedule.workouts!.add(workout);
            }
          }
        }
      }

      state = ret.copyWith(workoutSchedules: tempScheduleList);
    } catch (e) {
      state = WorkoutResultModelError(message: '데이터를 불러올수 없습니다.');
    }
  }
}
