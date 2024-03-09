import 'package:fitend_trainer_app/common/const/pallete.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatelessWidget {
  const Calendar({
    super.key,
    this.selectedDay,
    required this.focusedDay,
    required this.onDaySelected,
    required this.firstDay,
    required this.lastDay,
  });
  final DateTime? selectedDay;
  final DateTime focusedDay;
  final DateTime firstDay;
  final DateTime lastDay;
  final OnDaySelected onDaySelected;

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      startingDayOfWeek: StartingDayOfWeek.monday,
      focusedDay: focusedDay,
      firstDay: firstDay,
      lastDay: lastDay,
      daysOfWeekVisible: true,
      headerStyle: const HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 19,
        ),
        leftChevronVisible: false,
        rightChevronVisible: false,
      ),
      calendarStyle: CalendarStyle(
        isTodayHighlighted: true,
        todayTextStyle: const TextStyle(
          color: Colors.black,
        ),
        todayDecoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(
            color: Pallete.point,
          ),
          shape: BoxShape.circle,
        ),
        outsideTextStyle: const TextStyle(
          color: Colors.black,
        ),
        weekendTextStyle: const TextStyle(
          color: Colors.red,
        ),
        selectedDecoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Pallete.point,
        ),
        selectedTextStyle: const TextStyle(
          color: Colors.white,
        ),
        // outsideDecoration: const BoxDecoration(
        //   shape: BoxShape.rectangle,
        // ),
      ),
      onDaySelected: onDaySelected,
      selectedDayPredicate: (day) {
        if (selectedDay == null) {
          return false;
        }

        return day.year == selectedDay!.year &&
            day.month == selectedDay!.month &&
            day.day == selectedDay!.day;
      },
      availableGestures: AvailableGestures.all,
    );
  }
}
