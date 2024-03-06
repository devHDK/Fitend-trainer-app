import 'package:fitend_trainer_app/common/component/dialog_widgets.dart';
import 'package:fitend_trainer_app/common/const/aseet_constants.dart';
import 'package:fitend_trainer_app/common/const/data_constants.dart';
import 'package:fitend_trainer_app/common/const/pallete.dart';
import 'package:fitend_trainer_app/common/const/text_style.dart';
import 'package:fitend_trainer_app/common/utils/data_utils.dart';
import 'package:fitend_trainer_app/common/utils/shared_pref_utils.dart';
import 'package:fitend_trainer_app/meeting/compoenet/empty_schedule_card.dart';
import 'package:fitend_trainer_app/meeting/compoenet/meeting_schedule_card.dart';
import 'package:fitend_trainer_app/meeting/model/meeting_schedule_model.dart';
import 'package:fitend_trainer_app/meeting/model/schedule_model.dart';
import 'package:fitend_trainer_app/meeting/provider/schedule_provider.dart';
import 'package:fitend_trainer_app/meeting/view/meeting_create_screen.dart';
import 'package:fitend_trainer_app/thread/utils/thread_push_update_utils.dart';
import 'package:fitend_trainer_app/trainer/model/trainer_model.dart';
import 'package:fitend_trainer_app/trainer/provider/get_me_provider.dart';
import 'package:fitend_trainer_app/trainer/provider/go_router.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScheduleScreen extends ConsumerStatefulWidget {
  static String get routeName => 'schedule_main';
  const ScheduleScreen({super.key});

  @override
  ConsumerState<ScheduleScreen> createState() => ScheduleScreenState();
}

class ScheduleScreenState extends ConsumerState<ScheduleScreen>
    with WidgetsBindingObserver, RouteAware {
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  DateTime today = DateTime.now();
  DateTime fifteenDaysAgo = DateTime.now().subtract(const Duration(days: 15));
  DateTime minDate = DateTime(DateTime.now().year);
  DateTime maxDate = DateTime(DateTime.now().year);
  bool initial = true;
  bool buildInitial = true;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    itemPositionsListener.itemPositions.addListener(_handleItemPositionChange);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (initial) {
        // _getScheduleInitial();
        // _checkHasData(scheduleListGlobal, context);
        initial = false;
      }

      fetch();
    });
  }

  void fetch() async {
    if (mounted && ref.read(scheduleProvider) is ScheduleModelError) {
      await ref
          .read(scheduleProvider.notifier)
          .paginate(startDate: fifteenDaysAgo);
    }
  }

  void _handleItemPositionChange() {
    if (mounted) {
      int maxIndex = itemPositionsListener.itemPositions.value
          .where((position) => position.itemLeadingEdge > 0)
          .reduce((maxPosition, currPosition) =>
              currPosition.itemLeadingEdge > maxPosition.itemLeadingEdge
                  ? currPosition
                  : maxPosition)
          .index;
      int minIndex = itemPositionsListener.itemPositions.value
          .where((position) => position.itemTrailingEdge < 1)
          .reduce((minPosition, currPosition) =>
              currPosition.itemLeadingEdge < minPosition.itemLeadingEdge
                  ? currPosition
                  : minPosition)
          .index;

      final items = ref.read(scheduleProvider) as ScheduleModel;
      int itemCount = items.data.length;

      ref.read(scheduleProvider.notifier).updateScrollIndex(minIndex);

      if (maxIndex > itemCount - 1 && !isLoading) {
        //스크롤을 아래로 내렸을때
        isLoading = true;

        ref
            .read(scheduleProvider.notifier)
            .paginate(
              startDate: maxDate,
              fetchMore: true,
              isDownScrolling: true,
            )
            .then((value) {
          isLoading = false;
        });
      } else if (minIndex == 1 && !isLoading) {
        isLoading = true;

        ref
            .read(scheduleProvider.notifier)
            .paginate(
              startDate: minDate,
              fetchMore: true,
              isUpScrolling: true,
            )
            .then((value) {
          if (mounted) {
            itemScrollController.jumpTo(index: 32);
            isLoading = false;
          }
        });
      }
    }
  }

  // void _getScheduleInitial() async {
  //   await ref
  //       .read(scheduleProvider.notifier)
  //       .paginate(startDate: DataUtils.getDate(fifteenDaysAgo))
  //       .then((value) {
  //     _checkHasData(scheduleListGlobal, context);
  //   });

  //   initial = false;
  // }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        await _checkIsNeedUpdate();
        await ThreadUpdateUtils.checkThreadNeedUpdate(ref);

        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.detached:
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }

  @override
  void didPush() async {
    await _checkIsNeedUpdate();
    if (mounted) {
      await ThreadUpdateUtils.checkThreadNeedUpdate(ref);
    }

    super.didPush();
  }

  Future<void> _checkIsNeedUpdate() async {
    if (mounted) {
      final pref = await SharedPreferences.getInstance();
      final isNeedUpdate = SharedPrefUtils.getIsNeedUpdate(
          StringConstants.needScheduleUpdate, pref);

      if (isNeedUpdate) {
        await _resetScheduleList();
        await SharedPrefUtils.updateIsNeedUpdate(
            StringConstants.needScheduleUpdate, pref, false);
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    ref
        .read(routeObserverProvider)
        .subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void dispose() {
    // ref.read(routeObserverProvider).unsubscribe(this);

    WidgetsBinding.instance.removeObserver(this);
    itemPositionsListener.itemPositions
        .removeListener(_handleItemPositionChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(scheduleProvider);
    final userState = ref.watch(getMeProvider);

    if (state is ScheduleModelLoading || userState is TrainerModelLoading) {
      return const Scaffold(
        backgroundColor: Pallete.background,
        body: Center(
          child: CircularProgressIndicator(
            color: Pallete.point,
          ),
        ),
      );
    }

    if (state is ScheduleModelError) {
      return Scaffold(
        backgroundColor: Pallete.background,
        body: Center(
          child: DialogWidgets.oneButtonDialog(
            message: '데이터를 불러오지 못했습니다.',
            confirmText: '새로 고침',
            confirmOnTap: () {
              ref.invalidate(scheduleProvider);
            },
            dismissable: false,
          ),
        ),
      );
    }

    final trainerModel = ref.watch(getMeProvider) as TrainerModel;
    final schedules = state as ScheduleModel;

    minDate = schedules.data.first.startDate.subtract(const Duration(days: 31));
    maxDate = schedules.data.last.startDate.add(const Duration(days: 1));

    return Stack(
      children: [
        ScrollablePositionedList.builder(
          itemScrollController: itemScrollController,
          itemPositionsListener: itemPositionsListener,
          initialScrollIndex:
              schedules.scrollIndex != null ? schedules.scrollIndex! : 15,
          itemCount: schedules.data.length + 2,
          itemBuilder: (context, index) {
            if (index == schedules.data.length + 1 || index == 0) {
              return const SizedBox(
                height: 100,
                child: Center(
                  child: CircularProgressIndicator(color: Pallete.point),
                ),
              );
            }

            final model = schedules.data[index - 1].schedule;

            if (model!.isEmpty) {
              return Column(
                children: [
                  if (schedules.data[index - 1].startDate.day == 1)
                    Container(
                      height: 34,
                      color: Pallete.darkGray,
                      child: Center(
                        child: Text(
                          DateFormat('yyyy년 M월')
                              .format(schedules.data[index - 1].startDate),
                          style: h3Headline.copyWith(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  EmptyScheduleCard(
                    date: schedules.data[index - 1].startDate,
                  ),
                ],
              );
            }

            if (model.isNotEmpty) {
              return Column(
                children: [
                  if (schedules.data[index - 1].startDate.day == 1)
                    Container(
                      height: 34,
                      color: Pallete.darkGray,
                      child: Center(
                        child: Text(
                          DateFormat('yyyy년 M월')
                              .format(schedules.data[index - 1].startDate),
                          style: h3Headline.copyWith(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ...model.mapIndexed(
                    (seq, e) {
                      return InkWell(
                        onTap: () {
                          if (model[seq].selected!) {
                            return;
                          }
                          if (mounted) {
                            setState(
                              () {
                                for (var e in schedules.data) {
                                  for (var element in e.schedule!) {
                                    element.selected = false;
                                  }
                                }
                                model[seq].selected = true;
                              },
                            );
                          }
                        },
                        child: MeetingScheduleCard.fromMeetingSchedule(
                          date: schedules.data[index - 1].startDate,
                          model: e as MeetingSchedule,
                          isDateVisible: seq == 0 ? true : false,
                          trainer: trainerModel.trainer,
                        ),
                      );
                    },
                  )
                ],
              );
            }
            return const SizedBox();
          },
        ),
        Positioned(
          right: 28,
          bottom: 20,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(CupertinoPageRoute(
                builder: (context) => const MeetingCreateScreen(),
              ));
            },
            backgroundColor: Colors.transparent,
            child: SvgPicture.asset(SVGConstants.threadCreateButton),
          ),
        ),
      ],
    );
  }

  Future<void> _resetScheduleList() async {
    await ref
        .read(scheduleProvider.notifier)
        .paginate(
          startDate: DataUtils.getDate(fifteenDaysAgo),
        )
        .then((value) {
      if (mounted) {
        itemScrollController.jumpTo(index: 15);
      }
    });
  }

  void tapLogo() async {
    await ref
        .read(scheduleProvider.notifier)
        .paginate(
          startDate: DataUtils.getDate(fifteenDaysAgo),
        )
        .then((value) {
      if (mounted) {
        itemScrollController.jumpTo(index: 15);
      }
    });
  }
}
