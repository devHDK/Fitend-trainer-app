import 'package:fitend_trainer_app/common/component/calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ndialog/ndialog.dart';

class CalendarDialog extends ConsumerStatefulWidget {
  CalendarDialog({
    super.key,
    required this.selectedDate,
  });

  DateTime selectedDate;

  @override
  ConsumerState<CalendarDialog> createState() => _CalendarDialogState();
}

class _CalendarDialogState extends ConsumerState<CalendarDialog> {
  DateTime? selectedDay;
  DateTime? focusedDay;
  Map<String, List<dynamic>>? dateData = {};
  DateTime today = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  @override
  void initState() {
    super.initState();
    selectedDay = widget.selectedDate;
  }

  @override
  Widget build(BuildContext context) {
    return DialogBackground(
      blur: 0.2,
      dialog: Dialog(
        backgroundColor: Colors.transparent,
        child: SingleChildScrollView(
          child: Container(
            width: 319,
            height: 460,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Calendar(
                    focusedDay: today,
                    selectedDay: selectedDay != null ? selectedDay! : null,
                    firstDay: today,
                    lastDay: today.add(const Duration(days: 365)),
                    onDaySelected: (selectedDay, focusedDay) {
                      if (mounted) {
                        setState(() {
                          this.selectedDay = selectedDay;
                        });
                      }
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          if (selectedDay != null) {
                            context.pop({'selectedDay': selectedDay});
                          }
                        },
                        child: const Text(
                          '확인',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () => context.pop(),
                        child: const Text(
                          '취소',
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
