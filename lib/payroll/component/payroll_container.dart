import 'package:fitend_trainer_app/common/const/pallete.dart';
import 'package:fitend_trainer_app/common/const/text_style.dart';
import 'package:flutter/material.dart';

class PayrollContainer extends StatelessWidget {
  final String title;
  final String? subTile;
  final String content;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final Widget? child;

  const PayrollContainer({
    super.key,
    required this.title,
    this.subTile,
    required this.content,
    this.backgroundColor = Pallete.darkGray,
    this.textColor = Colors.white,
    this.borderColor = Pallete.darkGray,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: backgroundColor,
        border: Border.all(
          color: borderColor!,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      title,
                      style: s1SubTitle.copyWith(
                        color: textColor,
                      ),
                    ),
                    const SizedBox(width: 5),
                    if (subTile != null)
                      Text(
                        subTile!,
                        style: s3SubTitle.copyWith(
                          color: Pallete.gray,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  content,
                  style: h3Headline.copyWith(
                    color: textColor,
                  ),
                ),
              ],
            ),
            if (child != null) child!
          ],
        ),
      ),
    );
  }
}
