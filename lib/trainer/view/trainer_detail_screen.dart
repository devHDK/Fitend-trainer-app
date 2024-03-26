import 'package:fitend_trainer_app/common/component/custom_network_image.dart';
import 'package:fitend_trainer_app/common/component/dialog_widgets.dart';
import 'package:fitend_trainer_app/common/const/aseet_constants.dart';
import 'package:fitend_trainer_app/common/const/data_constants.dart';
import 'package:fitend_trainer_app/common/const/pallete.dart';
import 'package:fitend_trainer_app/common/const/text_style.dart';
import 'package:fitend_trainer_app/trainer/model/trainer_detail_model.dart';
import 'package:fitend_trainer_app/trainer/provider/trainer_detail_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class TrainerDetailScreen extends ConsumerStatefulWidget {
  const TrainerDetailScreen({
    super.key,
  });

  @override
  ConsumerState<TrainerDetailScreen> createState() =>
      _TrainerDetailScreenState();
}

class _TrainerDetailScreenState extends ConsumerState<TrainerDetailScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (ref.read(trainerDetailProvider) is TrainerDetailModelError) {
        ref.read(trainerDetailProvider.notifier).getTrainerDetail();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(trainerDetailProvider);

    if (state is TrainerDetailModelLoading) {
      return const Scaffold(
        backgroundColor: Pallete.background,
        body: Center(
          child: CircularProgressIndicator(
            color: Pallete.point,
          ),
        ),
      );
    }

    if (state is TrainerDetailModelError) {
      return Scaffold(
        backgroundColor: Pallete.background,
        body: Center(
          child: DialogWidgets.oneButtonDialog(
            message: state.message,
            confirmText: '확인',
            confirmOnTap: () => context.pop(),
          ),
        ),
      );
    }

    final trainerModel = state as TrainerDetailModel;

    return Scaffold(
      backgroundColor: Pallete.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Pallete.background,
        title: Text(
          '코치 프로필',
          style: h3Headline.copyWith(color: Colors.white),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Padding(
            padding: EdgeInsets.only(left: 10),
            child: Icon(Icons.arrow_back),
          ),
        ),
      ),
      body: ListView(
        children: [
          SizedBox(
            width: 100.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 25,
                      ),
                      _introProfile(trainerModel),
                      const SizedBox(
                        height: 20,
                      ),

                      //소개
                      Text('소개',
                          style: h4Headline.copyWith(color: Colors.white)),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        trainerModel.intro,
                        style: s1SubTitle.copyWith(color: Colors.white),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      //자격사항
                      Text('자격 사항',
                          style: h4Headline.copyWith(color: Colors.white)),
                      const SizedBox(
                        height: 10,
                      ),
                      ...trainerModel.qualification.data.map(
                        (e) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: Text(
                              '✅ $e',
                              style: s1SubTitle.copyWith(color: Colors.white),
                            ),
                          );
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
                const Divider(
                  color: Pallete.darkGray,
                  thickness: 13,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      //전문 분야
                      Text('전문 분야',
                          style: h4Headline.copyWith(color: Colors.white)),
                      const SizedBox(
                        height: 10,
                      ),
                      ...trainerModel.speciality.data.map(
                        (e) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: Text(
                              '📌 $e',
                              style: s1SubTitle.copyWith(color: Colors.white),
                            ),
                          );
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      //코칭 스타일
                      Text('코칭 스타일',
                          style: h4Headline.copyWith(color: Colors.white)),
                      const SizedBox(
                        height: 10,
                      ),
                      ...trainerModel.speciality.data.map(
                        (e) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: Text(
                              '✨ $e',
                              style: s1SubTitle.copyWith(color: Colors.white),
                            ),
                          );
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      //코칭 스타일
                      Text('좋아하는 것',
                          style: h4Headline.copyWith(color: Colors.white)),
                      const SizedBox(
                        height: 10,
                      ),
                      ...trainerModel.favorite.data.map(
                        (e) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: Text(
                              '🌈 $e',
                              style: s1SubTitle.copyWith(color: Colors.white),
                            ),
                          );
                        },
                      ),
                      const SizedBox(
                        height: 100,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  SizedBox _introProfile(TrainerDetailModel trainerModel) {
    return SizedBox(
      width: 100.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: SizedBox(
              width: 80,
              height: 80,
              child: CustomNetworkImage(
                  imageUrl:
                      '${URLConstants.s3Url}${trainerModel.profileImage}'),
            ),
          ),
          const SizedBox(
            height: 14,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                trainerModel.nickname,
                style: h4Headline.copyWith(
                  color: Colors.white,
                  height: 1,
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              InkWell(
                onTap: () {
                  launchUrl(
                    Uri.parse(trainerModel.instagram),
                    mode: LaunchMode.externalApplication,
                  );
                },
                child: SvgPicture.asset(SVGConstants.instagram),
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            trainerModel.shortIntro,
            style: s2SubTitle.copyWith(
              color: Pallete.lightGray,
            ),
          ),
        ],
      ),
    );
  }
}
