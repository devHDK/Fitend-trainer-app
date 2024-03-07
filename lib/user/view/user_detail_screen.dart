import 'package:cached_network_image/cached_network_image.dart';
import 'package:fitend_trainer_app/common/component/dialog_widgets.dart';
import 'package:fitend_trainer_app/common/const/data_constants.dart';
import 'package:fitend_trainer_app/common/const/pallete.dart';
import 'package:fitend_trainer_app/common/const/text_style.dart';
import 'package:fitend_trainer_app/common/utils/data_utils.dart';
import 'package:fitend_trainer_app/thread/component/profile_image.dart';
import 'package:fitend_trainer_app/user/model/user_detail_model.dart';
import 'package:fitend_trainer_app/user/provider/user_detail_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class UserDetailScreen extends ConsumerStatefulWidget {
  const UserDetailScreen({
    super.key,
    required this.userId,
  });

  final int userId;

  @override
  ConsumerState<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends ConsumerState<UserDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(userDetailProvider(widget.userId));

    if (state is UserDetailModelLoading) {
      return const Scaffold(
        backgroundColor: Pallete.background,
        body: Center(
          child: CircularProgressIndicator(
            color: Pallete.point,
          ),
        ),
      );
    }

    if (state is UserDetailModelError) {
      return Scaffold(
        backgroundColor: Pallete.background,
        body: Center(
          child: DialogWidgets.oneButtonDialog(
            message: '데이터를 불러오지 못했습니다.',
            confirmText: '새로 고침',
            confirmOnTap: () {
              ref.read(userDetailProvider(widget.userId).notifier).init();
            },
            dismissable: false,
          ),
        ),
      );
    }

    final model = state as UserDetailModel;

    print(model.toJson());

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 28),
            child: GestureDetector(
              onTap: () => context.pop(),
              child: const Icon(Icons.close_sharp),
            ),
          )
        ],
        title: Text(
          '회원 프로필',
          style: h4Headline.copyWith(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 25,
            ),
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 80,
                    child: CircleProfileImage(
                      image: CachedNetworkImage(
                          imageUrl: model.gender == 'male'
                              ? URLConstants.maleProfileUrl
                              : URLConstants.femaleProfileUrl),
                      borderRadius: 40,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    model.nickname,
                    style: h4Headline.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${DataUtils.getDateString(model.createdAt)} 가입',
                    style: s2SubTitle.copyWith(color: Pallete.lightGray),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
