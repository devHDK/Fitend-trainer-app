import 'package:fitend_trainer_app/common/const/pallete.dart';
import 'package:fitend_trainer_app/common/const/text_style.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CustomTimePicker extends StatefulWidget {
  final int hour;
  final int minute;

  const CustomTimePicker({
    super.key,
    required this.hour,
    required this.minute,
  });

  @override
  State<CustomTimePicker> createState() => _CustomTimePickerState();
}

class _CustomTimePickerState extends State<CustomTimePicker> {
  int hour = 0;
  int minute = 0;

  @override
  void initState() {
    super.initState();

    hour = widget.hour;
    minute = widget.minute;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              NumberPicker(
                haptics: true,
                textStyle: h1Headline.copyWith(color: Pallete.gray),
                selectedTextStyle: h1Headline.copyWith(
                  color: Pallete.point,
                ),
                minValue: 0,
                maxValue: 23,
                value: hour,
                onChanged: (value) {
                  if (mounted) {
                    setState(() {
                      hour = value;
                    });
                  }
                },
              ),
              Text(
                ':',
                style: s1SubTitle.copyWith(
                  fontSize: 22,
                ),
              ),
              NumberPicker(
                haptics: true,
                textStyle: h1Headline.copyWith(color: Pallete.gray),
                selectedTextStyle: h1Headline.copyWith(
                  color: Pallete.point,
                ),
                minValue: 0,
                maxValue: 45,
                step: 15,
                value: minute,
                onChanged: (value) {
                  if (mounted) {
                    setState(() {
                      minute = value;
                    });
                  }
                },
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  context.pop();
                },
                child: Container(
                  width: 40.w,
                  height: 44,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Pallete.gray,
                  ),
                  child: Center(
                    child: Text(
                      '취소',
                      style: h2Headline.copyWith(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  if (mounted) {
                    context.pop({
                      "hour": hour,
                      "minute": minute,
                    });
                  }
                },
                child: Container(
                  width: 40.w,
                  height: 44,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Pallete.point,
                  ),
                  child: Center(
                    child: Text(
                      '완료',
                      style: h2Headline.copyWith(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
