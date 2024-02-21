import 'package:fitend_trainer_app/common/component/dialog_widgets.dart';
import 'package:fitend_trainer_app/common/const/data_constants.dart';
import 'package:fitend_trainer_app/common/const/pallete.dart';
import 'package:fitend_trainer_app/common/const/text_style.dart';
import 'package:fitend_trainer_app/common/utils/shared_pref_utils.dart';
import 'package:fitend_trainer_app/notifications/component/notification_cell.dart';
import 'package:fitend_trainer_app/notifications/model/notification_model.dart';
import 'package:fitend_trainer_app/notifications/provider/notification_home_screen_provider.dart';
import 'package:fitend_trainer_app/notifications/provider/notification_provider.dart';
import 'package:fitend_trainer_app/notifications/repository/notifications_repository.dart';
import 'package:fitend_trainer_app/trainer/provider/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:scrolls_to_top/scrolls_to_top.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationScreen extends ConsumerStatefulWidget {
  static String get routeName => 'notification';

  const NotificationScreen({super.key});

  @override
  ConsumerState<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends ConsumerState<NotificationScreen>
    with RouteAware, WidgetsBindingObserver {
  final ScrollController controller = ScrollController();
  late NotificationModel notification;
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();

    controller.addListener(listener);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ref
        .read(routeObserverProvider)
        .subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void didPush() async {
    putNotification();

    await ref.read(notificationRepositoryProvider).putNotificationsConfirm();
    await FlutterAppBadger.removeBadge();
    super.didPush();
  }

  @override
  void didPop() async {
    await ref.read(notificationProvider.notifier).putNotification();
    ref.read(notificationHomeProvider.notifier).updateIsConfirm(true);
    super.didPop();
  }

  Future<void> putNotification() async {
    final pref = await SharedPreferences.getInstance();
    final isNeedUpdateNoti = SharedPrefUtils.getIsNeedUpdate(
        StringConstants.needNotificationUpdate, pref);

    if (isNeedUpdateNoti) {
      await ref.read(notificationProvider.notifier).paginate();
      await SharedPrefUtils.updateIsNeedUpdate(
          StringConstants.needNotificationUpdate, pref, false);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        await putNotification();
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
  void dispose() async {
    // ref.read(routeObserverProvider).unsubscribe(this);
    WidgetsBinding.instance.removeObserver(this);
    controller.removeListener(listener);
    super.dispose();
  }

  void listener() async {
    if (mounted) {
      final provider = ref.read(notificationProvider.notifier);

      if (notification.data != null &&
          controller.offset > controller.position.maxScrollExtent - 100 &&
          notification.data!.length < notification.total) {
        //스크롤을 아래로 내렸을때
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
          await provider.paginate(
              start: notification.data!.length, fetchMore: true);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(notificationProvider);

    if (state is NotificationModelLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Pallete.point,
        ),
      );
    }

    if (state is NotificationModelError) {
      return Center(
        child: DialogWidgets.oneButtonDialog(
          message: state.message,
          confirmText: '확인',
          confirmOnTap: () => context.pop(),
        ),
      );
    }

    notification = state as NotificationModel;

    return state.total == 0
        ? Center(
            child: Text(
              '새로운 알림이 없어요 😅',
              style: s1SubTitle.copyWith(
                color: Pallete.lightGray,
              ),
            ),
          )
        : RefreshIndicator(
            backgroundColor: Pallete.background,
            color: Pallete.point,
            semanticsLabel: '새로고침',
            onRefresh: () async {
              await ref.read(notificationProvider.notifier).paginate();
            },
            child: ListView.builder(
              controller: controller,
              itemCount: state.data!.length + 1,
              itemBuilder: (context, index) {
                if (index == notification.data!.length &&
                    state.data!.length < state.total) {
                  return const SizedBox(
                    height: 100,
                    child: Center(
                      child: CircularProgressIndicator(color: Pallete.point),
                    ),
                  );
                }

                if (index == notification.data!.length &&
                    state.data!.length == state.total) {
                  return const SizedBox();
                }

                return GestureDetector(
                  onTap: notification.data![index].type == 'thread' &&
                          notification.data![index].info != null &&
                          notification.data![index].info!.threadId != null
                      ? () {
                          // _pushThreadScreen(context, index);
                          ref
                              .read(notificationProvider.notifier)
                              .putNotificationChcek(index);
                        }
                      : () {
                          ref
                              .read(notificationProvider.notifier)
                              .putNotificationChcek(index);
                        },
                  child: NotificationCell(
                    notificationData: notification.data![index],
                  ),
                );
              },
            ),
          );
  }

  // void _pushThreadScreen(BuildContext context, int index) {
  //   Navigator.of(context).push(
  //     CupertinoPageRoute(
  //       builder: (context) => ThreadDetailScreen(
  //           threadId: notification.data![index].info!.threadId!),
  //     ),
  //   );
  // }
}
