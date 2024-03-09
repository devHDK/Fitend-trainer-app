import 'package:fitend_trainer_app/common/provider/shared_preference_provider.dart';
import 'package:fitend_trainer_app/common/utils/data_utils.dart';
import 'package:fitend_trainer_app/meeting/model/get_schedule_pagenate_params.dart';
import 'package:fitend_trainer_app/meeting/model/meeting_schedule_model.dart';
import 'package:fitend_trainer_app/meeting/model/schedule_model.dart';
import 'package:fitend_trainer_app/meeting/repository/meeting_schedule_repository.dart';
import 'package:fitend_trainer_app/trainer/model/trainer_model.dart';
import 'package:fitend_trainer_app/trainer/provider/get_me_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final scheduleProvider =
    StateNotifierProvider<ScheduleStateNotifier, ScheduleModelBase>((ref) {
  final meetingRepository = ref.watch(meetingRepositoryProvider);
  final trainer = ref.watch(getMeProvider) as TrainerModel;
  final sharedPref = ref.watch(sharedPrefsProvider);

  return ScheduleStateNotifier(
    meetingRepository: meetingRepository,
    sharedPref: sharedPref,
    trainer: trainer,
  );
});

class ScheduleStateNotifier extends StateNotifier<ScheduleModelBase> {
  final MeetingRepository meetingRepository;
  final Future<SharedPreferences> sharedPref;
  final TrainerModel trainer;

  ScheduleStateNotifier({
    required this.meetingRepository,
    required this.sharedPref,
    required this.trainer,
  }) : super(ScheduleModelLoading()) {
    DateTime fifteenDaysAgo = DateTime.now().subtract(const Duration(days: 15));
    paginate(
      startDate: DataUtils.getDate(fifteenDaysAgo),
    );
  }

  Future<void> paginate({
    required DateTime startDate,
    bool fetchMore = false,
    bool isRefetch = false,
    bool isUpScrolling = false,
    bool isDownScrolling = false,
  }) async {
    try {
      final isLoading = state is ScheduleModelLoading;
      final isRefetching = state is ScheduleModelRefetching;
      final isFetchMore = state is ScheduleModelFetchingMore;

      if (fetchMore && (isLoading || isFetchMore || isRefetching)) {
        return;
      }

      if (fetchMore) {
        // 데이터를 추가로 가져오는 상황
        final pState = state as ScheduleModel;

        state = ScheduleModelFetchingMore(data: pState.data);
      } else {
        if (state is ScheduleModel) {
          final pState = state as ScheduleModel;
          state = ScheduleModelRefetching(data: pState.data);
        } else {
          state = ScheduleModelLoading();
        }
      }
      final meetingResponse = await meetingRepository.getMeetings(
        model: SchedulePagenateParams(
          startDate: startDate,
          endDate: startDate.add(const Duration(days: 31)),
          trainerId: trainer.trainer.id,
        ),
      );

      List<ScheduleData> tempScheduleList = List.generate(
        31,
        (index) => ScheduleData(
          startDate: startDate.add(Duration(days: index)),
          schedule: [],
        ),
      );

      if (meetingResponse.data.isNotEmpty) {
        for (var scheduleDate in tempScheduleList) {
          for (var meetingSchedule in meetingResponse.data) {
            if (scheduleDate.startDate.year == meetingSchedule.startTime.year &&
                scheduleDate.startDate.month ==
                    meetingSchedule.startTime.month &&
                scheduleDate.startDate.day == meetingSchedule.startTime.day) {
              scheduleDate.schedule!.add(meetingSchedule);

              if (scheduleDate.startDate.year == DateTime.now().year &&
                  scheduleDate.startDate.month == DateTime.now().month &&
                  scheduleDate.startDate.day == DateTime.now().day) {
                scheduleDate.schedule![0].selected = true;
              } else {}
            }
          }
        }
      }

      if (state is ScheduleModelFetchingMore) {
        final pState = state as ScheduleModel;
        if (isUpScrolling) {
          state = ScheduleModel(
            data: <ScheduleData>[
              ...tempScheduleList,
              ...pState.data,
            ],
          );
        } else if (isDownScrolling) {
          state = ScheduleModel(
            data: <ScheduleData>[
              ...pState.data,
              ...tempScheduleList,
            ],
          );
        }
      } else {
        state = ScheduleModel(
          data: tempScheduleList,
          scrollIndex: 15,
        );
        // if (state is ScheduleModel) {
        //   final pstate = state as ScheduleModel;
        //   scheduleListGlobal = pstate.data;
        // }
      }
    } catch (e) {
      debugPrint('e : ScheduleModelError');
      state = ScheduleModelError(message: '데이터를 불러오지 못했습니다.');
    }
  }

  void updateScrollIndex(int scrollIndex) {
    final pstate = state as ScheduleModel;

    pstate.scrollIndex = scrollIndex;

    state = pstate;
  }

  void addMeetingSchedule({required MeetingSchedule model}) {
    final pstate = state as ScheduleModel;

    final scheduleIndex = pstate.data.indexWhere((schedule) {
      return schedule.startDate.year == model.startTime.year &&
          schedule.startDate.month == model.startTime.month &&
          schedule.startDate.day == model.startTime.day;
    });

    if (scheduleIndex == -1) return;

    if (pstate.data[scheduleIndex].schedule!.isEmpty) {
      pstate.data[scheduleIndex].schedule!.add(model);
    } else {
      int insertIndex =
          pstate.data[scheduleIndex].schedule!.indexWhere((meeting) {
        return (meeting.startTime.compareTo(model.startTime) >= 0);
      });

      if (insertIndex == -1) {
        pstate.data[scheduleIndex].schedule!.add(model);
      } else {
        pstate.data[scheduleIndex].schedule!.insert(insertIndex, model);
      }
    }

    state = pstate.copyWith();
  }

  void updateMeetingSchedule({
    required DateTime originStartTime,
    required MeetingSchedule model,
  }) {
    final pstate = state as ScheduleModel;

    final beforeScheduleIndex = pstate.data.indexWhere((schedule) {
      return schedule.startDate.year == originStartTime.year &&
          schedule.startDate.month == originStartTime.month &&
          schedule.startDate.day == originStartTime.day;
    });

    //이전 meeting schedule에서 삭제
    pstate.data[beforeScheduleIndex].schedule!.removeWhere((element) {
      final meeting = element as MeetingSchedule;

      return meeting.id == model.id;
    });

    //해당 일자 서치
    final afterScheduleIndex = pstate.data.indexWhere((schedule) {
      return schedule.startDate.year == model.startTime.year &&
          schedule.startDate.month == model.startTime.month &&
          schedule.startDate.day == model.startTime.day;
    });

    //캐시에 없을경우 패스
    if (afterScheduleIndex == -1) return;

    //해당 일자로 추가
    if (pstate.data[afterScheduleIndex].schedule!.isEmpty) {
      pstate.data[afterScheduleIndex].schedule!.add(model);
    } else {
      int insertIndex =
          pstate.data[afterScheduleIndex].schedule!.indexWhere((meeting) {
        return (meeting.startTime.compareTo(model.startTime) >= 0);
      });

      if (insertIndex == -1) {
        pstate.data[afterScheduleIndex].schedule!.add(model);
      } else {
        pstate.data[afterScheduleIndex].schedule!.insert(insertIndex, model);
      }
    }

    state = pstate.copyWith();
  }

  void deleteMeetingSchedule({
    required MeetingSchedule model,
  }) {
    final pstate = state as ScheduleModel;

    final index = pstate.data.indexWhere((schedule) {
      return schedule.startDate.year == model.startTime.year &&
          schedule.startDate.month == model.startTime.month &&
          schedule.startDate.day == model.startTime.day;
    });

    pstate.data[index].schedule!.removeWhere((element) {
      final meeting = element as MeetingSchedule;

      return meeting.id == model.id;
    });

    state = pstate.copyWith();
  }
}
