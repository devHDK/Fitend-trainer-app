import 'package:fitend_trainer_app/common/const/data_constants.dart';
import 'package:fitend_trainer_app/common/const/pallete.dart';
import 'package:fitend_trainer_app/common/const/text_style.dart';
import 'package:fitend_trainer_app/common/utils/data_utils.dart';
import 'package:fitend_trainer_app/thread/model/result/workout_result_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ScheduleResultSetInfoScreen extends ConsumerStatefulWidget {
  final List<Exercise> exercises;
  final String startDate;
  final int workoutScheduleId;

  const ScheduleResultSetInfoScreen({
    super.key,
    required this.exercises,
    required this.startDate,
    required this.workoutScheduleId,
  });

  @override
  ConsumerState<ScheduleResultSetInfoScreen> createState() =>
      _ScheduleResultSetInfoScreenState();
}

class _ScheduleResultSetInfoScreenState
    extends ConsumerState<ScheduleResultSetInfoScreen> {
  int completeCount = 0;

  @override
  Widget build(BuildContext context) {
    for (var exercise in widget.exercises) {
      for (var setInfo in exercise.recordSetInfo) {
        if (setInfo.weight != null ||
            setInfo.reps != null ||
            setInfo.seconds != null) {
          completeCount++;
          break;
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Pallete.background,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Padding(
              padding: EdgeInsets.only(left: 10),
              child: Icon(Icons.arrow_back)),
        ),
        title: Text(
          '${DateFormat('M월 d일').format(DateTime.parse(widget.startDate))} ${weekday[DateTime.parse(widget.startDate).weekday - 1]}요일',
          style: h4Headline,
        ),
        centerTitle: true,
        elevation: 0,
      ),
      backgroundColor: Pallete.background,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '총 $completeCount개의 운동을 완료했어요 🏋🏼‍♂️',
                    style: h4Headline.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const Divider(
                    color: Pallete.gray,
                    thickness: 1,
                  ),
                  const SizedBox(
                    height: 9,
                  )
                ],
              ),
            ),
            SliverList.separated(
              itemCount: widget.exercises.length,
              itemBuilder: (context, index) {
                Set targetMuscles = {};
                for (var targetMuscle
                    in widget.exercises[index].targetMuscles) {
                  if (targetMuscle.type == 'main') {
                    targetMuscles.add(targetMuscle.name);
                  }
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.exercises[index].name,
                          style: h5Headline.copyWith(
                            color: Colors.white,
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      targetMuscles.join(' ∙ '),
                      style: s2SubTitle.copyWith(color: Pallete.lightGray),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Container(
                      width: 100.w,
                      decoration: BoxDecoration(
                        color: Pallete.darkGray,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 10,
                        ),
                        child: Column(
                          children: [
                            ...widget.exercises[index].setInfo.map((set) {
                              switch (widget.exercises[index].trackingFieldId) {
                                case 1:
                                  return _setInfoCellWeightReps(set);
                                case 2:
                                  return _setInfoCellReps(set);
                                default:
                                  return _setInfoCellTimer(set);
                              }
                            })
                          ],
                        ),
                      ),
                    )
                  ],
                );
              },
              separatorBuilder: (context, index) => const SizedBox(height: 30),
            )
          ],
        ),
      ),
    );
  }

  Padding _setInfoCellWeightReps(SetInfo set) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${set.index} Set',
            style: s2SubTitle.copyWith(
              color: Pallete.lightGray,
            ),
          ),
          Text(
            set.weight != null ? '${set.weight}kg' : '-',
            style: s2SubTitle.copyWith(
              color: Pallete.lightGray,
            ),
          ),
          Text(
            set.reps != null ? '${set.reps}회' : '-',
            style: s2SubTitle.copyWith(
              color: Pallete.lightGray,
            ),
          ),
          Text(
            set.reps != null && set.weight != null ? '✅' : '❌',
          ),
        ],
      ),
    );
  }

  Padding _setInfoCellReps(SetInfo set) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${set.index} Set',
            style: s2SubTitle.copyWith(
              color: Pallete.lightGray,
            ),
          ),
          Text(
            set.reps != null ? '${set.reps}회' : '-',
            style: s2SubTitle.copyWith(
              color: Pallete.lightGray,
            ),
          ),
          Text(
            set.reps != null ? '✅' : '❌',
          ),
        ],
      ),
    );
  }

  Padding _setInfoCellTimer(SetInfo set) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${set.index} Set',
            style: s2SubTitle.copyWith(
              color: Pallete.lightGray,
            ),
          ),
          Text(
            set.seconds != null
                ? DataUtils.getTimeStringHour(set.seconds!)
                : '-',
            style: s2SubTitle.copyWith(
              color: Pallete.lightGray,
            ),
          ),
          Text(
            set.seconds != null ? '✅' : '❌',
          ),
        ],
      ),
    );
  }
}
