import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:fitend_trainer_app/common/component/dialog_widgets.dart';
import 'package:fitend_trainer_app/common/const/aseet_constants.dart';
import 'package:fitend_trainer_app/common/const/data_constants.dart';
import 'package:fitend_trainer_app/common/const/pallete.dart';
import 'package:fitend_trainer_app/common/const/text_style.dart';
import 'package:fitend_trainer_app/common/utils/data_utils.dart';
import 'package:fitend_trainer_app/meeting/provider/schedule_provider.dart';
import 'package:fitend_trainer_app/notifications/model/notification_setting_model.dart';
import 'package:fitend_trainer_app/notifications/provider/notification_home_screen_provider.dart';
import 'package:fitend_trainer_app/notifications/provider/notification_provider.dart';
import 'package:fitend_trainer_app/notifications/repository/notifications_repository.dart';
import 'package:fitend_trainer_app/thread/component/profile_image.dart';
import 'package:fitend_trainer_app/thread/provider/comment_create_provider.dart';
import 'package:fitend_trainer_app/thread/provider/thread_create_provider.dart';
import 'package:fitend_trainer_app/thread/provider/thread_detail_provider.dart';
import 'package:fitend_trainer_app/thread/provider/thread_provider.dart';
import 'package:fitend_trainer_app/trainer/model/trainer_model.dart';
import 'package:fitend_trainer_app/trainer/provider/get_me_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';

class MyPageScreen extends ConsumerStatefulWidget {
  static String get routeName => 'mypage';
  const MyPageScreen({super.key});

  @override
  ConsumerState<MyPageScreen> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends ConsumerState<MyPageScreen> {
  PackageInfo? packageInfo;
  String? version;

  @override
  void initState() {
    super.initState();
    getPackage();
  }

  void getPackage() async {
    packageInfo = await PackageInfo.fromPlatform();
    if (mounted) {
      setState(() {
        version = packageInfo!.version;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(getMeProvider);

    if (state is TrainerModelLoading || state is TrainerModelError) {
      return const Center(
          child: CircularProgressIndicator(
        color: Pallete.point,
      ));
    }

    final model = state as TrainerModel;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        children: [
          const SizedBox(
            height: 17,
          ),
          SizedBox(
            width: 80,
            child: CircleProfileImage(
              image: CachedNetworkImage(
                imageUrl: '${URLConstants.s3Url}${model.trainer.profileImage}',
              ),
              borderRadius: 40,
            ),
          ),
          const SizedBox(
            height: 14,
          ),
          Text(
            model.trainer.nickname,
            style: h4Headline.copyWith(
              color: Colors.white,
            ),
          ),
          const SizedBox(
            height: 21,
          ),
          const Divider(
            color: Pallete.darkGray,
            height: 1,
          ),
          _renderLabel(
              name: '알림 설정',
              child: SizedBox(
                width: 42,
                height: 24,
                child: Transform.scale(
                  scale: 0.7,
                  child: CupertinoSwitch(
                    activeColor: Pallete.point,
                    trackColor: Pallete.gray,
                    value: state.trainer.isNotification,
                    onChanged: (value) async {
                      try {
                        ref.read(getMeProvider.notifier).changeIsNotification(
                            isNotification: !state.trainer.isNotification);

                        await ref
                            .read(notificationRepositoryProvider)
                            .putNotificationsSetting(
                                body: NotificationSettingParams(
                                    isNotification:
                                        !state.trainer.isNotification));
                      } on DioException catch (e) {
                        debugPrint('$e');
                        ref.read(getMeProvider.notifier).changeIsNotification(
                            isNotification: !state.trainer.isNotification);
                      }
                    },
                  ),
                ),
              )),
          const Divider(
            color: Pallete.darkGray,
            height: 1,
          ),
          InkWell(
            onTap: () =>
                DataUtils.onWebViewTap(uri: URLConstants.notionServiceUser),
            child: _renderLabel(
              name: '서비스 이용약관',
              child: SvgPicture.asset(SVGConstants.next),
            ),
          ),
          const Divider(
            color: Pallete.darkGray,
            height: 1,
          ),
          InkWell(
            onTap: () =>
                DataUtils.onWebViewTap(uri: URLConstants.notionPrivacy),
            child: _renderLabel(
              name: '개인정보 처리방침',
              child: SvgPicture.asset(SVGConstants.next),
            ),
          ),
          const Divider(
            color: Pallete.darkGray,
            height: 1,
          ),
          _renderLabel(
            name: '현재 버전',
            child: Text(
              packageInfo != null ? 'v${packageInfo!.version}' : '',
              style: s3SubTitle.copyWith(
                color: Pallete.point,
              ),
            ),
          ),
          const Divider(
            color: Pallete.darkGray,
            height: 1,
          ),
          InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => DialogWidgets.confirmDialog(
                  message: '로그아웃 하시겠습니까?',
                  confirmText: '확인',
                  cancelText: '취소',
                  confirmOnTap: () async {
                    await ref.read(getMeProvider.notifier).logout();

                    ref.invalidate(threadProvider);
                    ref.invalidate(threadDetailProvider);

                    ref.invalidate(scheduleProvider);

                    ref.invalidate(threadCreateProvider);
                    ref.invalidate(commentCreateProvider);

                    ref.invalidate(notificationProvider);
                    ref.invalidate(notificationHomeProvider);
                  },
                  cancelOnTap: () => context.pop(),
                ),
              );
            },
            child: _renderLabel(
              name: '로그아웃',
            ),
          ),
        ],
      ),
    );
  }

  Padding _renderLabel({required String name, Widget? child}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            name,
            style: s1SubTitle.copyWith(
              color: Colors.white,
            ),
          ),
          if (child != null) child,
        ],
      ),
    );
  }
}
