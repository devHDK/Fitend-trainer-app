import 'package:dio/dio.dart';
import 'package:fitend_trainer_app/common/component/custom_number_picker.dart';
import 'package:fitend_trainer_app/common/component/custom_time_picker.dart';
import 'package:fitend_trainer_app/common/component/date_picker.dart';
import 'package:fitend_trainer_app/common/component/dialog_widgets.dart';
import 'package:fitend_trainer_app/common/const/aseet_constants.dart';
import 'package:fitend_trainer_app/common/const/pallete.dart';
import 'package:fitend_trainer_app/common/const/text_style.dart';
import 'package:fitend_trainer_app/common/utils/data_utils.dart';
import 'package:fitend_trainer_app/meeting/model/meeting_schedule_model.dart';
import 'package:fitend_trainer_app/meeting/provider/meeting_update_provider.dart';
import 'package:fitend_trainer_app/meeting/provider/schedule_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:ndialog/ndialog.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class MeetingUpdateScreen extends ConsumerStatefulWidget {
  const MeetingUpdateScreen({
    super.key,
    required this.meeting,
  });

  final MeetingSchedule meeting;

  @override
  ConsumerState<MeetingUpdateScreen> createState() =>
      _MeetingUpdateScreenState();
}

class _MeetingUpdateScreenState extends ConsumerState<MeetingUpdateScreen> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(meetingUpdateProvider(widget.meeting.id).notifier).init(
          startTime: widget.meeting.startTime, endTime: widget.meeting.endTime);
    });
  }

  @override
  Widget build(BuildContext context) {
    final model = ref.watch(meetingUpdateProvider(widget.meeting.id));

    if (model == null) {
      return const Scaffold(
        backgroundColor: Pallete.background,
        body: Center(
          child: CircularProgressIndicator(
            color: Pallete.point,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Padding(
            padding: EdgeInsets.only(left: 10),
            child: Icon(Icons.arrow_back),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 18),
            child: TextButton(
              onPressed: () async {
                try {
                  await ref
                      .read(meetingUpdateProvider(widget.meeting.id).notifier)
                      .deleteMeeting()
                      .then(
                    (value) {
                      DialogWidgets.showToast(
                        content: '미팅일정을 삭제했어요 ✅',
                        gravity: ToastGravity.CENTER,
                      );

                      ref
                          .read(scheduleProvider.notifier)
                          .deleteMeetingSchedule(model: widget.meeting);

                      context.pop();
                    },
                  );
                } catch (e) {
                  DialogWidgets.oneButtonDialog(
                    message: '다시 시도해 주세요!',
                    confirmText: '확인',
                    confirmOnTap: () => context.pop(),
                  );
                }
              },
              child: Text(
                '삭제하기',
                style: h6Headline.copyWith(color: Pallete.point),
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 37),
                Text(
                  '미팅 스케줄을 입력해주세요.',
                  style: h3Headline.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 35),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '회원',
                      style: s2SubTitle.copyWith(color: Pallete.lightGray),
                    ),
                    const SizedBox(width: 55),
                    Expanded(
                      child: Container(
                        height: 44,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(width: 1, color: Pallete.darkGray),
                        ),
                        child: Center(
                          child: Text(
                            widget.meeting.userNickname,
                            style: s1SubTitle.copyWith(
                              color: Pallete.gray,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '날짜',
                      style: s2SubTitle.copyWith(color: Pallete.lightGray),
                    ),
                    const SizedBox(width: 55),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return CalendarDialog(
                                selectedDate: model.startTime,
                              );
                            },
                          ).then(
                            (value) {
                              if (value != null) {
                                DateTime selectedDay = value['selectedDay'];
                                final changedStartTime = DateTime(
                                    selectedDay.year,
                                    selectedDay.month,
                                    selectedDay.day,
                                    model.startTime.hour,
                                    model.startTime.minute);

                                if (changedStartTime.isBefore(DateTime.now())) {
                                  DialogWidgets.showToast(
                                    content: '현재 시간보다 이후에 시간을 설정해 주세요',
                                    gravity: ToastGravity.CENTER,
                                  );

                                  ref
                                      .read(meetingUpdateProvider(
                                              widget.meeting.id)
                                          .notifier)
                                      .init(
                                        startTime: widget.meeting.startTime,
                                        endTime: widget.meeting.endTime,
                                      );
                                } else {
                                  ref
                                      .read(meetingUpdateProvider(
                                              widget.meeting.id)
                                          .notifier)
                                      .updateState(
                                        startTime: changedStartTime,
                                        endTime: changedStartTime
                                            .add(const Duration(minutes: 15)),
                                      );
                                }
                              }
                            },
                          );
                        },
                        child: Stack(
                          children: [
                            Container(
                              height: 44,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    width: 1, color: Pallete.darkGray),
                              ),
                              child: Center(
                                child: Text(
                                  DataUtils.getDateString(model.startTime),
                                  style:
                                      s1SubTitle.copyWith(color: Colors.white),
                                ),
                              ),
                            ),
                            Positioned(
                              right: 18,
                              top: 11,
                              child: SvgPicture.asset(
                                SVGConstants.calendar,
                                height: 20,
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '시간',
                      style: s2SubTitle.copyWith(color: Pallete.lightGray),
                    ),
                    const SizedBox(width: 55),
                    Expanded(
                      flex: 2,
                      child: GestureDetector(
                        onTap: () async {
                          await showCupertinoModalPopup(
                            context: context,
                            builder: (BuildContext context) {
                              return _buildContainer(
                                CustomTimePicker(
                                  hour: model.startTime.hour,
                                  minute: model.startTime.minute,
                                ),
                              );
                            },
                          ).then((value) {
                            if (value != null) {
                              final hour = value['hour'];
                              final minute = value['minute'];

                              final changedStartTime = DateTime(
                                  model.startTime.year,
                                  model.startTime.month,
                                  model.startTime.day,
                                  hour,
                                  minute);

                              if (changedStartTime.isBefore(DateTime.now())) {
                                DialogWidgets.showToast(
                                  content: '현재 시간보다 이후에 시간을 설정해 주세요',
                                  gravity: ToastGravity.CENTER,
                                );
                              } else {
                                ref
                                    .read(
                                        meetingUpdateProvider(widget.meeting.id)
                                            .notifier)
                                    .updateState(
                                      startTime: changedStartTime,
                                      endTime: changedStartTime
                                          .add(const Duration(minutes: 15)),
                                    );
                              }
                            }
                          });
                        },
                        child: Container(
                          height: 44,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border:
                                Border.all(width: 1, color: Pallete.darkGray),
                          ),
                          child: Center(
                            child: Text(
                              DataUtils.getTimeString(model.startTime),
                              style: s1SubTitle.copyWith(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: () async {
                          await showCupertinoModalPopup(
                            context: context,
                            builder: (BuildContext context) {
                              return _buildContainer(
                                CustomNumberPicker(
                                  minute: model.endTime
                                      .difference(model.startTime)
                                      .inMinutes,
                                ),
                              );
                            },
                          ).then((value) {
                            if (value != null) {
                              int minute = value['minute'];
                              DateTime changedEndTime = model.startTime
                                  .add(Duration(minutes: minute));

                              ref
                                  .read(meetingUpdateProvider(widget.meeting.id)
                                      .notifier)
                                  .updateState(
                                    endTime: changedEndTime,
                                  );
                            }
                          });
                        },
                        child: Container(
                          height: 44,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border:
                                Border.all(width: 1, color: Pallete.darkGray),
                          ),
                          child: Center(
                            child: Text(
                              '${model.endTime.difference(model.startTime).inMinutes.toString()} 분',
                              style: s1SubTitle.copyWith(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: TextButton(
        onPressed: !isLoading
            ? () async {
                try {
                  setState(() {
                    isLoading = true;
                  });

                  if (model.startTime.isBefore(DateTime.now())) {
                    DialogWidgets.showToast(
                      content: '현재 시간보다 이후에 시간을 설정해 주세요',
                      gravity: ToastGravity.CENTER,
                    );

                    setState(() {
                      isLoading = false;
                    });

                    return;
                  }

                  await ref
                      .read(meetingUpdateProvider(widget.meeting.id).notifier)
                      .updateMeeting()
                      .then((value) {
                    DialogWidgets.showToast(
                      content: '미팅일정을 수정했어요 ✅',
                      gravity: ToastGravity.CENTER,
                    );

                    ref.read(scheduleProvider.notifier).updateMeetingSchedule(
                          originStartTime: widget.meeting.startTime,
                          model: MeetingSchedule(
                            id: widget.meeting.id,
                            startTime: model.startTime,
                            endTime: model.endTime,
                            status: 'complete',
                            userNickname: widget.meeting.userNickname,
                            trainer: widget.meeting.trainer,
                          ),
                        );

                    context.pop();
                  });
                } catch (e) {
                  debugPrint('$e');

                  if (!context.mounted) return;

                  String message = '다시 시도해주세요!';

                  if (e is DioException) {
                    if (e.response != null && e.response!.statusCode == 409) {
                      message = '선택하신 일정과 겹치는 스케줄이 있어요 😅';
                    }
                  }

                  DialogWidgets.oneButtonDialog(
                    message: message,
                    confirmText: '확인',
                    confirmOnTap: () => context.pop(),
                  ).show(context);

                  setState(() {
                    isLoading = false;
                  });
                }
              }
            : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Container(
            height: 44,
            width: 100.w,
            decoration: BoxDecoration(
              color: Pallete.point,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: isLoading
                  ? const SizedBox(
                      height: 35,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      '완료',
                      style: h6Headline.copyWith(color: Colors.white),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildContainer(Widget picker) {
  return Container(
    height: 260,
    padding: const EdgeInsets.only(top: 6.0),
    color: CupertinoColors.white,
    child: DefaultTextStyle(
      style: const TextStyle(
        color: CupertinoColors.black,
        fontSize: 22.0,
      ),
      child: GestureDetector(
        onTap: () {},
        child: SafeArea(
          top: false,
          child: picker,
        ),
      ),
    ),
  );
}
