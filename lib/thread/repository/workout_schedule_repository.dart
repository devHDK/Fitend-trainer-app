import 'package:dio/dio.dart' hide Headers;
import 'package:fitend_trainer_app/common/dio/dio.dart';
import 'package:fitend_trainer_app/thread/model/result/schedule_pagenate_params.dart';
import 'package:fitend_trainer_app/thread/model/result/workout_list_model.dart';
import 'package:fitend_trainer_app/thread/model/result/workout_result_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/retrofit.dart';

part 'workout_schedule_repository.g.dart';

final workoutScheduleRepositoryProvider =
    Provider<WorkoutScheduleRepository>((ref) {
  final dio = ref.watch(dioProvider);

  return WorkoutScheduleRepository(dio);
});

@RestApi()
abstract class WorkoutScheduleRepository {
  factory WorkoutScheduleRepository(Dio dio) = _WorkoutScheduleRepository;

  @GET('/workoutSchedules')
  @Headers({
    'accessToken': 'true',
  })
  Future<WorkoutList> getWorkoutSchedules({
    @Queries() required WorkoutSchedulePagenateParams params,
  });

  @GET('/workoutSchedules/{id}')
  @Headers({
    'accessToken': 'true',
  })
  Future<WorkoutResultModel> getWorkout({
    @Path('id') required int workoutScheduleId,
  });
}
