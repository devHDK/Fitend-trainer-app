import 'package:fitend_trainer_app/common/const/aseet_constants.dart';
import 'package:fitend_trainer_app/common/const/data_constants.dart';
import 'package:fitend_trainer_app/common/const/pallete.dart';
import 'package:fitend_trainer_app/common/const/text_style.dart';
import 'package:fitend_trainer_app/meeting/model/meeting_schedule_model.dart';
import 'package:fitend_trainer_app/trainer/model/trainer_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class MeetingScheduleCard extends ConsumerStatefulWidget {
  final DateTime? date;
  final String? title;
  final String? subTitle;
  final DateTime startTime;
  final DateTime endTime;
  final bool? isDateVisible;
  final int? id;
  final String? status;
  final String? userNickname;
  final String meetingLink;
  final bool selected;

  const MeetingScheduleCard({
    this.date,
    this.title,
    this.subTitle,
    super.key,
    required this.selected,
    required this.startTime,
    required this.endTime,
    this.isDateVisible = true,
    this.id,
    this.status,
    this.userNickname,
    required this.meetingLink,
  });

  factory MeetingScheduleCard.fromMeetingSchedule({
    required MeetigSchedule model,
    DateTime? date,
    bool? isDateVisible,
    required Trainer trainer,
  }) {
    return MeetingScheduleCard(
      date: date,
      title: '${model.userNickname} 회원님과 미팅이 있어요 👋',
      subTitle:
          '${DateFormat('HH:mm').format(model.startTime.toUtc().toLocal())} ~ ${DateFormat('HH:mm').format(model.endTime.toUtc().toLocal())} (${model.endTime.difference(model.startTime.toUtc().toLocal()).inMinutes}분)',
      selected: model.selected!,
      isDateVisible: isDateVisible,
      meetingLink: trainer.meetingLink,
      startTime: model.startTime,
      endTime: model.endTime,
    );
  }

  @override
  ConsumerState<MeetingScheduleCard> createState() => _ScheduleCardState();
}

class _ScheduleCardState extends ConsumerState<MeetingScheduleCard> {
  DateTime today = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.selected ? 175 : 130,
      width: 100.w,
      decoration: BoxDecoration(
        color: Colors.transparent,
        image: widget.selected
            ? const DecorationImage(
                image: AssetImage(IMGConstants.scheduleMeeting),
                fit: BoxFit.fill,
                opacity: 0.3,
              )
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 35,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: (widget.selected &&
                                  widget.isDateVisible! &&
                                  widget.date != null) ||
                              (widget.date != null &&
                                  widget.date!.compareTo(today) == 0 &&
                                  widget.isDateVisible == true) ||
                              widget.selected
                          ? Colors.white
                          : Colors.transparent,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    // image: ,
                  ),
                  width: 39,
                  height: 58,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    child: Column(
                      children: [
                        if (widget.date != null)
                          Text(
                            weekday[widget.date!.weekday - 1],
                            style: s2SubTitle.copyWith(
                              color: widget.isDateVisible! || widget.selected
                                  ? Colors.white
                                  : Colors.transparent,
                              letterSpacing: 0,
                              height: 1.2,
                            ),
                          ),
                        const SizedBox(
                          height: 5,
                        ),
                        if (widget.date != null)
                          Text(
                            widget.date!.day.toString(),
                            style: s2SubTitle.copyWith(
                              color: widget.isDateVisible! || widget.selected
                                  ? Colors.white
                                  : Colors.transparent,
                              letterSpacing: 0,
                              height: 1.2,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title != null ? widget.title! : '',
                        style: h4Headline.copyWith(
                          color: Colors.white,
                          overflow: TextOverflow.ellipsis,
                        ),
                        maxLines: 1,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        widget.subTitle != null ? widget.subTitle! : '',
                        style: s2SubTitle.copyWith(
                          color: Pallete.lightGray,
                          overflow: TextOverflow.ellipsis,
                        ),
                        maxLines: 1,
                      )
                    ],
                  ),
                ),
              ],
            ),
            if (widget.selected)
              Column(
                children: [
                  const SizedBox(
                    height: 23,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 1,
                        child: _Button(
                          widget: widget,
                          color: Pallete.point,
                          onTap: () {
                            //TODO: 수정페이지
                          },
                          child: Text(
                            '수정하기',
                            style: h6Headline.copyWith(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        flex: 1,
                        child: _Button(
                          widget: widget,
                          color: Pallete.zoomBlue,
                          onTap: () {
                            launchUrl(
                              Uri.parse(widget.meetingLink),
                              mode: LaunchMode.externalApplication,
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.videocam,
                                size: 19,
                                color: Pallete.lightGray,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                'Zoom',
                                style: h6Headline.copyWith(
                                  color: Colors.white,
                                  height: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            if (!widget.selected)
              const SizedBox(
                height: 35,
              ),
            const Divider(
              color: Pallete.darkGray,
              height: 1,
            ),
          ],
        ),
      ),
    );
  }
}

class _Button extends StatelessWidget {
  const _Button({
    required this.widget,
    required this.child,
    required this.color,
    required this.onTap,
  });

  final MeetingScheduleCard widget;
  final Widget child;
  final Color color;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: color,
        ),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent, elevation: 0),
            onPressed: () {
              onTap();
            },
            child: child),
      ),
    );
  }
}
