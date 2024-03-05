import 'package:dio/dio.dart';
import 'package:fitend_trainer_app/meeting/model/put_meeting_model.dart';
import 'package:fitend_trainer_app/meeting/repository/meeting_schedule_repository.dart';
import 'package:fitend_trainer_app/trainer/model/trainer_model.dart';
import 'package:fitend_trainer_app/trainer/provider/get_me_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final meetingUpdateProvider = AutoDisposeStateNotifierProviderFamily<
    MeetingUpdateNotifier, PutMeetingModel?, int>((ref, id) {
  final meetingRepository = ref.watch(meetingRepositoryProvider);
  final trainer = ref.watch(getMeProvider) as TrainerModel;

  return MeetingUpdateNotifier(
    id: id,
    meetingRepository: meetingRepository,
    trainer: trainer,
  );
});

class MeetingUpdateNotifier extends StateNotifier<PutMeetingModel?> {
  final int id;
  final MeetingRepository meetingRepository;
  final TrainerModel trainer;

  MeetingUpdateNotifier({
    required this.id,
    required this.meetingRepository,
    required this.trainer,
  }) : super(null);

  void init({required DateTime startTime, required DateTime endTime}) {
    state = PutMeetingModel(
      status: 'complete',
      startTime: startTime,
      endTime: endTime,
    );
  }

  void updateState({
    DateTime? startTime,
    DateTime? endTime,
  }) {
    final pstate = state!.copyWith();

    if (startTime != null) {
      pstate.startTime = startTime;
    }
    if (endTime != null) {
      pstate.endTime = endTime;
    }

    state = pstate.copyWith();
  }

  Future<void> updateMeeting() async {
    try {
      final pstate = state!.copyWith();
      await meetingRepository.putMeeting(id: id, model: pstate);
    } on DioException catch (e) {
      if (e.response != null) {
        e.response!.statusCode == 409;
        throw DioException(requestOptions: e.requestOptions);
      } else {
        rethrow;
      }
    }
  }
}
