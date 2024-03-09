import 'package:fitend_trainer_app/common/component/dialog_widgets.dart';
import 'package:fitend_trainer_app/common/const/pallete.dart';
import 'package:fitend_trainer_app/common/const/text_style.dart';
import 'package:fitend_trainer_app/payroll/component/payroll_container.dart';
import 'package:fitend_trainer_app/payroll/model/payroll_model.dart';
import 'package:fitend_trainer_app/payroll/provider/user_detail_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_month_picker/flutter_custom_month_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class PayrollScreen extends ConsumerStatefulWidget {
  const PayrollScreen({super.key});

  @override
  ConsumerState<PayrollScreen> createState() => _PayrollScreenState();
}

class _PayrollScreenState extends ConsumerState<PayrollScreen> {
  final today = DateTime.now();
  late DateTime date;
  late String monthYear;
  late String family;

  @override
  void initState() {
    super.initState();
    date = today;
    monthYear = DateFormat('yy년 M월').format(today);
    family = DateFormat('yyyy-MM-dd').format(today);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(payrollProvider(family));

    if (state is PayrollModelLoading) {
      return Scaffold(
        backgroundColor: Pallete.background,
        appBar: _monthAppBar(context),
        body: const Center(
          child: CircularProgressIndicator(
            color: Pallete.point,
          ),
        ),
      );
    }

    if (state is PayrollModelError) {
      return Scaffold(
        backgroundColor: Pallete.background,
        body: Center(
          child: DialogWidgets.oneButtonDialog(
            message: '데이터를 불러오지 못했습니다.',
            confirmText: '새로 고침',
            confirmOnTap: () {
              ref.read(payrollProvider(family).notifier).init();
            },
            dismissable: false,
          ),
        ),
      );
    }

    final model = state as PayrollModel;

    return Scaffold(
      appBar: _monthAppBar(context),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  PayrollContainer(
                    title: DateFormat('yyyy년 MM월').format(date),
                    subTile:
                        today.year == date.year && today.month == date.month
                            ? '(오늘 기준)'
                            : null,
                    content:
                        '${NumberFormat('#,###').format(model.wageInfo.wage)} 원',
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  if (today.year == date.year && today.month == date.month)
                    PayrollContainer(
                      title: '말일자 기준 예상금액',
                      content:
                          '${NumberFormat('#,###').format(model.wageInfo.monthEndWage)} 원',
                      textColor: Pallete.point,
                      backgroundColor: Colors.white,
                      borderColor: Pallete.point,
                    ),
                  const SizedBox(height: 35),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '회원별 세부내역 🏷️',
                        style: h4Headline.copyWith(color: Colors.white),
                      ),
                      Text(
                        '총 ${model.coaching.total}명',
                        style: s3SubTitle.copyWith(color: Pallete.lightGray),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SliverList.separated(
              itemBuilder: (context, index) {
                final coachingModel = model.coaching.data[index];

                return _memberPayrollCard(coachingModel);
              },
              separatorBuilder: (context, index) => const Divider(
                height: 1,
                color: Pallete.darkGray,
              ),
              itemCount: model.coaching.total,
            )
          ],
        ),
      ),
    );
  }

  SizedBox _memberPayrollCard(CoachingData coachingModel) {
    return SizedBox(
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                coachingModel.nickname,
                style: h5Headline.copyWith(color: Pallete.lightGray),
              ),
              const SizedBox(height: 4),
              Text(
                coachingModel.type == 0
                    ? '무료체험 이용중 ∙ ${coachingModel.usedDay}일'
                    : '${coachingModel.type}개월권 이용중 ∙ ${coachingModel.usedDay}일',
                style: s2SubTitle.copyWith(color: Pallete.lightGray),
              ),
            ],
          ),
          Text(
            '${NumberFormat('#,###').format(coachingModel.payroll)} 원',
            style: h5Headline.copyWith(color: Pallete.lightGray),
          ),
        ],
      ),
    );
  }

  AppBar _monthAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: () => context.pop(),
        icon: const Padding(
          padding: EdgeInsets.only(left: 10),
          child: Icon(Icons.arrow_back),
        ),
      ),
      title: GestureDetector(
        onTap: () async {
          showMonthPicker(
            context,
            onSelected: (month, year) {
              final nextMonth = DateTime(year, month + 1, 1);
              final lastMonth = nextMonth.subtract(const Duration(days: 1));

              if (lastMonth.isAfter(today)) {
                date = DateTime(year, month, today.day);
              } else {
                date = DateTime(lastMonth.year, lastMonth.month, lastMonth.day);
              }

              monthYear = DateFormat('yy년 M월').format(date);
              family = DateFormat('yyyy-MM-dd').format(date);
              setState(() {});
            },
            initialSelectedMonth: date.month,
            initialSelectedYear: date.year,
            firstYear: 2023,
            lastYear: today.year,
            firstEnabledMonth: 1,
            lastEnabledMonth: today.month,
            selectButtonText: '확인',
            cancelButtonText: '취소',
            highlightColor: Pallete.point,
            textColor: Colors.black,
            contentBackgroundColor: Colors.white,
            dialogBackgroundColor: Colors.grey[200],
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              monthYear,
              style: h3Headline.copyWith(color: Colors.white, height: 1),
            ),
            const SizedBox(
              width: 5,
            ),
            const Icon(
              Icons.keyboard_arrow_down,
              size: 20,
            )
          ],
        ),
      ),
      centerTitle: true,
    );
  }
}
