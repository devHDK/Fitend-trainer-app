import 'package:fitend_trainer_app/common/component/dialog_widgets.dart';
import 'package:fitend_trainer_app/common/const/aseet_constants.dart';
import 'package:fitend_trainer_app/common/const/data_constants.dart';
import 'package:fitend_trainer_app/common/const/pallete.dart';
import 'package:fitend_trainer_app/common/const/text_style.dart';
import 'package:fitend_trainer_app/common/utils/data_utils.dart';
import 'package:fitend_trainer_app/common/utils/shared_pref_utils.dart';
import 'package:fitend_trainer_app/thread/component/thread_cell.dart';
import 'package:fitend_trainer_app/thread/model/common/thread_trainer_model.dart';
import 'package:fitend_trainer_app/thread/model/common/thread_user_model.dart';
import 'package:fitend_trainer_app/thread/model/thread_family_model.dart';
import 'package:fitend_trainer_app/thread/model/threads/thread_create_model.dart';
import 'package:fitend_trainer_app/thread/model/threads/thread_list_model.dart';
import 'package:fitend_trainer_app/thread/provider/thread_create_provider.dart';
import 'package:fitend_trainer_app/thread/provider/thread_detail_provider.dart';
import 'package:fitend_trainer_app/thread/provider/thread_provider.dart';
import 'package:fitend_trainer_app/thread/utils/thread_push_update_utils.dart';
import 'package:fitend_trainer_app/thread/view/thread_create_screen.dart';
import 'package:fitend_trainer_app/thread/view/thread_detail_screen.dart';
import 'package:fitend_trainer_app/trainer/model/trainer_model.dart';
import 'package:fitend_trainer_app/trainer/provider/get_me_provider.dart';
import 'package:fitend_trainer_app/trainer/provider/go_router.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:scrolls_to_top/scrolls_to_top.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThreadScreen extends ConsumerStatefulWidget {
  static String get routeName => 'thread';

  const ThreadScreen({
    super.key,
    required this.user,
    required this.titleContent,
  });

  final ThreadUser user;
  final String titleContent;

  @override
  ConsumerState<ThreadScreen> createState() => ThreadScreenState();
}

class ThreadScreenState extends ConsumerState<ThreadScreen>
    with WidgetsBindingObserver, RouteAware {
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  ThreadListModel pstate = ThreadListModel(data: [], total: 0);

  bool isLoading = false;
  int startIndex = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
    itemPositionsListener.itemPositions.addListener(_handleItemPositionChange);

    //threadScreen 진입시 badgeCount => 0
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      updateBadge();
    });
  }

  void fetch() async {
    if (mounted &&
        ref.read(threadProvider(widget.user)) is ThreadListModelError) {
      await ref
          .read(threadProvider(widget.user).notifier)
          .paginate(
            startIndex: 0,
            isRefetch: true,
          )
          .then((value) {
        itemScrollController.jumpTo(index: 0);
        isLoading = false;
      });
    }
  }

  void updateBadge() {
    if (mounted) {
      // threadBadgeCountReset();
      // ref.read(notificationHomeProvider.notifier).updateBageCount(0);
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

      if (minIndex < 0) minIndex = 0;
      ref
          .read(threadProvider(widget.user).notifier)
          .updateScrollIndex(minIndex);

      if (pstate.data.isNotEmpty &&
          maxIndex > pstate.data.length - 2 &&
          pstate.total > pstate.data.length &&
          !isLoading) {
        //스크롤을 아래로 내렸을때

        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          isLoading = true;

          ref
              .read(threadProvider(widget.user).notifier)
              .paginate(startIndex: startIndex, fetchMore: true)
              .then((value) {
            isLoading = false;
            if (mounted) {
              setState(() {});
            }
          });
        });
      }
    }
  }

  void threadBadgeCountReset() async {
    final pref = await SharedPreferences.getInstance();
    SharedPrefUtils.updateThreadBadgeCount(pref, 'reset');
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        if (mounted) {
          await ThreadUpdateUtils.checkThreadNeedUpdate(ref);
        }
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
    if (mounted) {
      await ThreadUpdateUtils.checkThreadNeedUpdate(ref);
    }
    super.didPush();
  }

  @override
  void didPop() async {
    if (mounted) {
      await ThreadUpdateUtils.checkThreadNeedUpdate(ref);

      final state = ref.read(threadProvider(widget.user));
      if (state is ThreadListModel) {
        for (var thread in state.data) {
          if (thread.checked == false &&
              thread.userCommentCount != null &&
              thread.userCommentCount! > 0) {
            await ref
                .read(threadProvider(widget.user).notifier)
                .updateThreadChecked(threadId: thread.id);
          } else if (thread.checked == false &&
              thread.userCommentCount != null &&
              thread.userCommentCount! == 0) {
            await ref
                .read(threadProvider(widget.user).notifier)
                .updateCheckedAll(threadId: thread.id);
          }
        }
      }
    }
    super.didPop();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    itemPositionsListener.itemPositions
        .removeListener(_handleItemPositionChange);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ref
        .read(routeObserverProvider)
        .subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  Widget build(BuildContext context) {
    final trainerState = ref.watch(getMeProvider);
    final state = ref.watch(threadProvider(widget.user));
    // final notificationState = ref.watch(notificationHomeProvider);
    final threadCreateState = ref.watch(threadCreateProvider((widget.user)));

    if (state is ThreadListModelLoading ||
        trainerState is TrainerModelLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Pallete.point,
        ),
      );
    }

    if (state is ThreadListModelError) {
      return Center(
        child: DialogWidgets.oneButtonDialog(
          message: '데이터를 불러오지 못했습니다.',
          confirmText: '새로 고침',
          confirmOnTap: () {
            ref.invalidate(threadProvider);
          },
          dismissable: false,
        ),
      );
    }

    final trainer = trainerState as TrainerModel;
    pstate = state as ThreadListModel;
    // final notificationHomeModel = notificationState as NotificationMainModel;
    startIndex = state.data.length;

    return ScrollsToTop(
      onScrollsToTop: (event) async {
        tapTop();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Pallete.background,
          leading: IconButton(
            onPressed: () => context.pop(),
            icon: const Padding(
                padding: EdgeInsets.only(left: 10),
                child: Icon(Icons.arrow_back)),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                widget.user.nickname,
                style: h4Headline.copyWith(color: Colors.white),
              ),
              Text(
                widget.titleContent,
                style: s2SubTitle.copyWith(color: Pallete.lightGray),
              )
            ],
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: Stack(
          children: [
            state.data.isEmpty
                ? Center(
                    child: Text(
                      '아직 회원님과 함께한 쓰레드가 없어요 🙂',
                      style: s2SubTitle.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  )
                : RefreshIndicator(
                    backgroundColor: Pallete.background,
                    color: Pallete.point,
                    semanticsLabel: '새로고침',
                    onRefresh: () async {
                      if (mounted) {
                        isLoading = true;

                        await ref
                            .read(threadProvider(widget.user).notifier)
                            .paginate(
                              startIndex: 0,
                              isRefetch: true,
                            )
                            .then((value) {
                          itemScrollController.jumpTo(index: 0);
                          isLoading = false;
                        });
                      }
                    },
                    child: ScrollablePositionedList.builder(
                      // padding: const EdgeInsets.only(left: 28),
                      itemScrollController: itemScrollController,
                      initialScrollIndex: state.scrollIndex ?? 0,
                      itemPositionsListener: itemPositionsListener,
                      itemCount: state.data.length + 1,
                      itemBuilder: (context, index) {
                        if (index == state.data.length) {
                          if (state.data.length == state.total) {
                            return const SizedBox(
                              height: 100,
                            );
                          }

                          return const SizedBox(
                            height: 100,
                            child: Center(
                              child: CircularProgressIndicator(
                                  color: Pallete.point),
                            ),
                          );
                        }

                        final model = state.data[index];

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (index == 0 ||
                                DataUtils.getDateFromDateTime(
                                        DateTime.parse(model.createdAt)
                                            .toUtc()
                                            .toLocal()) !=
                                    DataUtils.getDateFromDateTime(
                                        DateTime.parse(
                                                state.data[index - 1].createdAt)
                                            .toUtc()
                                            .toLocal()))
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 28),
                                child: Text(
                                  DataUtils.getDateFromDateTime(
                                              DateTime.parse(model.createdAt)
                                                  .toUtc()
                                                  .toLocal()) ==
                                          DataUtils.getDateFromDateTime(
                                              DateTime.now())
                                      ? '오늘'
                                      : DataUtils.getDateFromDateTime(
                                                  DateTime.parse(model.createdAt)
                                                      .toUtc()
                                                      .toLocal()) ==
                                              DataUtils.getDateFromDateTime(
                                                  DateTime.now().subtract(
                                                      const Duration(days: 1)))
                                          ? '어제'
                                          : DataUtils.getMonthDayFromDateTime(
                                              DateTime.parse(model.createdAt)
                                                  .toUtc()
                                                  .toLocal()),
                                  style:
                                      h4Headline.copyWith(color: Colors.white),
                                ),
                              ),
                            GestureDetector(
                              onTap: () {
                                if (!mounted) return;

                                final family = ThreadFamilyModel(
                                    threadId: model.id, user: widget.user);

                                //읽음 처리
                                if ((model.checked != null &&
                                        !model.checked!) ||
                                    (model.commentChecked != null &&
                                        !model.commentChecked!)) {
                                  ref
                                      .read(
                                          threadDetailProvider(family).notifier)
                                      .updateChecked(threadId: model.id);

                                  ref
                                      .read(
                                          threadProvider(widget.user).notifier)
                                      .updateCheckedStateAll(
                                          threadId: model.id);
                                }

                                Navigator.of(context).push(CupertinoPageRoute(
                                  builder: (context) => ThreadDetailScreen(
                                    threadId: model.id,
                                    user: widget.user,
                                  ),
                                ));
                              },
                              child: Stack(
                                children: [
                                  ThreadCell(
                                    id: model.id,
                                    title: model.title,
                                    content: model.content,
                                    profileImageUrl: model.writerType ==
                                            'trainer'
                                        ? '${URLConstants.s3Url}${model.trainer.profileImage}'
                                        : model.user.gender == 'male'
                                            ? URLConstants.maleProfileUrl
                                            : URLConstants.femaleProfileUrl,
                                    nickname: model.writerType == 'trainer'
                                        ? model.trainer.nickname
                                        : model.user.nickname,
                                    dateTime: DateTime.parse(model.createdAt)
                                        .toUtc()
                                        .toLocal(),
                                    gallery: model.gallery,
                                    emojis: model.emojis,
                                    userCommentCount:
                                        model.userCommentCount != null
                                            ? model.userCommentCount!
                                            : 0,
                                    trainerCommentCount:
                                        model.trainerCommentCount != null
                                            ? model.trainerCommentCount!
                                            : 0,
                                    user: model.user,
                                    trainer: model.trainer,
                                    writerType: model.writerType,
                                    threadType: model.type,
                                    workoutInfo: model.workoutInfo,
                                  ),
                                  if ((model.commentChecked != null &&
                                          !model.commentChecked!) ||
                                      (model.checked != null &&
                                          !model.checked!))
                                    Positioned(
                                      left: 28,
                                      child:
                                          SvgPicture.asset(SVGConstants.redDot),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
            if (threadCreateState.isUploading &&
                threadCreateState.totalCount > 0)
              _uploadingStatusBar(threadCreateState),
            if (!threadCreateState.isUploading)
              Positioned(
                right: 28,
                bottom: 40,
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (context) => ThreadCreateScreen(
                          trainer: ThreadTrainer(
                            id: trainer.trainer.id,
                            nickname: trainer.trainer.nickname,
                            profileImage: trainer.trainer.profileImage,
                          ),
                          user: widget.user,
                        ),
                      ),
                    );
                  },
                  backgroundColor: Colors.transparent,
                  child: SvgPicture.asset(SVGConstants.threadCreateButton),
                ),
              ),
          ],
        ),
      ),
    );
  }

  PreferredSize _uploadingStatusBar(ThreadCreateTempModel threadCreateState) {
    return PreferredSize(
      preferredSize: Size(100.w, 30),
      child: Container(
        color: Pallete.background,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'UPLOADING',
                style: h6Headline.copyWith(
                  color: Pallete.lightGray,
                  height: 1,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              LoadingAnimationWidget.dotsTriangle(
                color: Pallete.lightGray,
                size: 15,
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: LinearProgressIndicator(
                  color: Pallete.point,
                  value: (threadCreateState.doneCount) /
                      threadCreateState.totalCount,
                  backgroundColor: Pallete.gray,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // void tapLogo() async {
  //   await ref
  //       .read(threadProvider(widget.user).notifier)
  //       .paginate(
  //         startIndex: 0,
  //         isRefetch: true,
  //       )
  //       .then((value) {
  //     itemScrollController.jumpTo(index: 0);
  //     isLoading = false;
  //   });
  // }

  void tapTop() async {
    itemScrollController.jumpTo(index: 0);
  }
}
