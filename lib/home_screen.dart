import 'dart:io';

import 'package:fitend_trainer_app/common/component/logo_appbar.dart';
import 'package:fitend_trainer_app/common/const/aseet_constants.dart';
import 'package:fitend_trainer_app/common/const/pallete.dart';
import 'package:fitend_trainer_app/common/provider/avail_camera_provider.dart';
import 'package:fitend_trainer_app/home/model/home_screen_state_model.dart';
import 'package:fitend_trainer_app/home/provider/home_screen_provider.dart';
import 'package:fitend_trainer_app/meeting/view/schedule_screen.dart';
import 'package:fitend_trainer_app/notifications/model/notificatiion_main_state_model.dart';
import 'package:fitend_trainer_app/notifications/provider/notification_home_screen_provider.dart';
import 'package:fitend_trainer_app/notifications/view/notification_screen.dart';
import 'package:fitend_trainer_app/thread/view/thread_user_list_screen.dart';
import 'package:fitend_trainer_app/trainer/view/mypage_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scrolls_to_top/scrolls_to_top.dart';

class HomeScreen extends ConsumerStatefulWidget {
  static String get routeName => 'home_screen';
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final GlobalKey<ScheduleScreenState> scheduleScreenKey = GlobalKey();
  final GlobalKey<ThreadUserListScreenState> threadScreenKey = GlobalKey();

  List<String> appBarTitle = [
    'S C H E D U L E',
    'T H R E A D S',
    'N O T I F Y',
    'P R O F I L E',
  ];

  List<String> activeIcons = [
    SVGConstants.scheduleActive,
    SVGConstants.messageActive,
    SVGConstants.alarmOffActive,
    SVGConstants.mypageActive,
  ];

  List<String> unactiveIcons = [
    SVGConstants.schedule,
    SVGConstants.message,
    SVGConstants.alarmOff,
    SVGConstants.mypage,
  ];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // ref.read(homeStateProvider.notifier).changeTapIndex(0);

      fetch();
    });
  }

  void fetch() async {
    if (mounted &&
        ref.read(notificationHomeProvider) is NotificationMainModelError) {
      await ref.read(notificationHomeProvider.notifier).init();
    }
  }

  @override
  Widget build(BuildContext context) {
    // AsyncValue<List<CameraDescription>> camerasAsyncValue =
    ref.watch(availableCamerasProvider);
    final model = ref.watch(homeStateProvider);
    final notificationState = ref.watch(notificationHomeProvider);

    if (notificationState is NotificationMainModelLoading) {
      return const Scaffold(
        backgroundColor: Pallete.background,
        body: Center(
          child: CircularProgressIndicator(
            color: Pallete.point,
          ),
        ),
      );
    }

    final notificationHomeModel = notificationState as NotificationMainModel;

    return WillPopScope(
      onWillPop: () async => false,
      child: ScrollsToTop(
        onScrollsToTop: (event) async {
          _tapTopLogo(model);
        },
        child: Scaffold(
          backgroundColor: Pallete.background,
          appBar: LogoAppbar(
            title: appBarTitle[model.tabIndex],
            tapLogo: () {
              _tapTopLogo(model);
            },
          ),
          bottomNavigationBar: BottomAppBar(
            color: Pallete.background,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Divider(
                  height: 1,
                  color: Pallete.gray,
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ...List.generate(
                      4,
                      (index) => _tapBarIconButton(
                        model: model,
                        index: index,
                        activeIcon: activeIcons[index],
                        unActiveIcon: unactiveIcons[index],
                        notificationHomeModel: notificationHomeModel,
                      ),
                    )
                  ],
                ),
                if (Platform.isAndroid)
                  const SizedBox(
                    height: 10,
                  ),
              ],
            ),
          ),
          body: model.tabIndex == 0
              ? ScheduleScreen(key: scheduleScreenKey)
              : model.tabIndex == 1
                  ? ThreadUserListScreen(key: threadScreenKey)
                  : model.tabIndex == 2
                      ? const NotificationScreen()
                      : const MyPageScreen(),
        ),
      ),
    );
  }

  void _tapTopLogo(HomeScreenStateModel model) {
    if (model.tabIndex == 0 && scheduleScreenKey.currentState != null) {
      scheduleScreenKey.currentState!.tapLogo();
    } else if (model.tabIndex == 1 && threadScreenKey.currentState != null) {
      threadScreenKey.currentState!.tapTop();
    }
  }

  InkWell _tapBarIconButton({
    required HomeScreenStateModel model,
    required int index,
    required String activeIcon,
    required String unActiveIcon,
    required NotificationMainModel notificationHomeModel,
  }) {
    return InkWell(
      onTap: () {
        if (mounted) {
          ref.read(homeStateProvider.notifier).changeTapIndex(index);

          if (index == 2) {
            ref.read(notificationHomeProvider.notifier).updateIsConfirm(true);
          }
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 30,
          vertical: 10,
        ),
        child: Stack(
          children: [
            SvgPicture.asset(
              model.tabIndex == index ? activeIcon : unActiveIcon,
              width: 24,
              height: 24,
            ),
            if (index == 2 && !notificationHomeModel.isConfirmed)
              Positioned(
                right: 0,
                child: SvgPicture.asset(SVGConstants.redDot),
              )
          ],
        ),
      ),
    );
  }
}
