import 'package:dio/dio.dart';
import 'package:fitend_trainer_app/meeting/model/post_meeting_model.dart';
import 'package:fitend_trainer_app/meeting/model/post_meeting_resp_model.dart';
import 'package:fitend_trainer_app/meeting/repository/meeting_schedule_repository.dart';
import 'package:fitend_trainer_app/trainer/model/trainer_model.dart';
import 'package:fitend_trainer_app/trainer/provider/get_me_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final meetingCreateProvider =
    StateNotifierProvider.autoDispose<MeetingCreateNotifier, PostMeetingModel>(
        (ref) {
  final meetingRepository = ref.watch(meetingRepositoryProvider);
  final trainer = ref.watch(getMeProvider) as TrainerModel;

  return MeetingCreateNotifier(
    meetingRepository: meetingRepository,
    trainer: trainer,
  );
});

class MeetingCreateNotifier extends StateNotifier<PostMeetingModel> {
  final MeetingRepository meetingRepository;
  final TrainerModel trainer;

  MeetingCreateNotifier({
    required this.meetingRepository,
    required this.trainer,
  }) : super(
          PostMeetingModel(
            trainerId: trainer.trainer.id,
          ),
        ) {
    init();
  }

  void init() {
    final pstate = state.copyWith();
    bool isOverHalfTime = false;

    DateTime now = DateTime.now();

    if (now.minute > 30) {
      isOverHalfTime = true;
      now = DateTime.now().add(const Duration(hours: 1));
    } else {
      isOverHalfTime = false;
    }

    DateTime startTime = DateTime(
        now.year, now.month, now.day, now.hour, isOverHalfTime ? 0 : 30);

    pstate.startTime = startTime;
    pstate.endTime = startTime.add(const Duration(minutes: 15));

    state = pstate.copyWith();
  }

  void updateState({
    int? userId,
    DateTime? startTime,
    DateTime? endTime,
  }) {
    final pstate = state.copyWith();

    if (userId != null) {
      pstate.userId = userId;
    }

    if (startTime != null) {
      pstate.startTime = startTime;
    }
    if (endTime != null) {
      pstate.endTime = endTime;
    }

    state = pstate.copyWith();
  }

  Future<PostMeetingResp> createMeeting() async {
    try {
      final pstate = state.copyWith();
      final ret = await meetingRepository.postMeeting(model: pstate);

      return ret;
    } catch (e) {
      rethrow;
    }
  }
}
