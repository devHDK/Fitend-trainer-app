import 'package:dio/dio.dart' hide Headers;
import 'package:fitend_trainer_app/common/dio/dio.dart';
import 'package:fitend_trainer_app/meeting/model/get_schedule_pagenate_params.dart';
import 'package:fitend_trainer_app/meeting/model/meeting_schedule_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/retrofit.dart';

part 'meeting_schedule_repository.g.dart';

final meetingRepositoryProvider = Provider<MeetingRepository>((ref) {
  final dio = ref.watch(dioProvider);

  return MeetingRepository(dio);
});

@RestApi()
abstract class MeetingRepository {
  factory MeetingRepository(Dio dio) = _MeetingRepository;

  @GET('/meetings')
  @Headers({
    'accessToken': 'true',
  })
  Future<MeetingScheduleModel> getMeetings({
    @Queries() required SchedulePagenateParams model,
  });
}
