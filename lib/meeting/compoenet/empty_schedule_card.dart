import 'package:fitend_trainer_app/common/const/data_constants.dart';
import 'package:fitend_trainer_app/common/const/pallete.dart';
import 'package:fitend_trainer_app/common/const/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class EmptyScheduleCard extends ConsumerStatefulWidget {
  final DateTime date;

  const EmptyScheduleCard({
    super.key,
    required this.date,
  });

  @override
  ConsumerState<EmptyScheduleCard> createState() => _ScheduleCardState();
}

class _ScheduleCardState extends ConsumerState<EmptyScheduleCard> {
  DateTime today = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  @override
  Widget build(BuildContext context) {
    final isToday = widget.date.compareTo(today) == 0;

    return Container(
      height: 130,
      width: 100.w,
      decoration: const BoxDecoration(color: Colors.transparent),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isToday ? Colors.white : Colors.transparent,
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
                          Text(
                            weekday[widget.date.weekday - 1],
                            style: s2SubTitle.copyWith(
                              color: Colors.white,
                              letterSpacing: 0,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            widget.date.day.toString(),
                            style: s2SubTitle.copyWith(
                              color: Colors.white,
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
                ],
              ),
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
