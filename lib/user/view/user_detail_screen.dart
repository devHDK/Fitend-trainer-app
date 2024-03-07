import 'package:cached_network_image/cached_network_image.dart';
import 'package:fitend_trainer_app/common/component/dialog_widgets.dart';
import 'package:fitend_trainer_app/common/const/aseet_constants.dart';
import 'package:fitend_trainer_app/common/const/data_constants.dart';
import 'package:fitend_trainer_app/common/const/pallete.dart';
import 'package:fitend_trainer_app/common/const/text_style.dart';
import 'package:fitend_trainer_app/common/utils/data_utils.dart';
import 'package:fitend_trainer_app/thread/component/profile_image.dart';
import 'package:fitend_trainer_app/user/model/user_detail_model.dart';
import 'package:fitend_trainer_app/user/provider/user_detail_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

enum Place { home, gym, both }

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

    String? workoutPlace;
    List<String> preferWorkoutDays = [];

    String experience = '';
    String purpose = '';
    List<String> achievementList = [];
    List<String> obstacleList = [];

    if (model.preSurvey != null) {
      if (model.preSurvey!.place == Place.home.name) {
        workoutPlace = '집';
      } else if (model.preSurvey!.place == Place.gym.name) {
        workoutPlace = '헬스장';
      } else {
        workoutPlace = '집 ∙ 헬스장';
      }

      for (var element in model.preSurvey!.preferDays) {
        preferWorkoutDays.add(weekday[element - 1]);
      }

      experience = SurveyConstants.experiences[model.preSurvey!.experience - 1];
      purpose = SurveyConstants.purposes[model.preSurvey!.experience - 1];

      for (var element in model.preSurvey!.achievement) {
        achievementList.add(SurveyConstants.achievements[element - 1]);
      }

      for (var element in model.preSurvey!.obstacle) {
        obstacleList.add(SurveyConstants.obstacles[element - 1]);
      }
    }

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
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 25),
                  _Profile(model: model),
                  const SizedBox(height: 30),
                  _bodySpecSection(model),
                  const SizedBox(height: 30),
                  _workoutFlavorSection(workoutPlace, preferWorkoutDays),
                  const SizedBox(height: 30),
                  if (model.preSurvey != null)
                    _preSurveySection(
                      experience,
                      purpose,
                      achievementList,
                      obstacleList,
                    )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Column _preSurveySection(String experience, String purpose,
      List<String> achievementList, List<String> obstacleList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '설문 결과',
          style: h4Headline.copyWith(color: Colors.white),
        ),
        const SizedBox(height: 12),
        _SurveyContainer(
          title: '1. 헬스를 해본 경험이 있으신가요?',
          child: Text(
            '  ∙  $experience',
            style: s1SubTitle.copyWith(
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 12),
        _SurveyContainer(
          title: '2. 가장 이루고 싶은 목표가 무엇인가요?',
          child: Text(
            '  ∙  $purpose',
            style: s1SubTitle.copyWith(
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 12),
        _SurveyContainer(
          title: '3. 어떨 때 성취감을 느끼시나요?',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...achievementList.map((e) => Text(
                    '  ∙  $e',
                    style: s1SubTitle.copyWith(
                      color: Colors.white,
                    ),
                  )),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _SurveyContainer(
          title: '4. 목표 달성에 장애물이 있나요?',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...obstacleList.map((e) => Text(
                    '  ∙  $e',
                    style: s1SubTitle.copyWith(
                      color: Colors.white,
                    ),
                  )),
            ],
          ),
        ),
        const SizedBox(
          height: 50,
        )
      ],
    );
  }

  Column _workoutFlavorSection(
      String? workoutPlace, List<String> preferWorkoutDays) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '운동 환경',
          style: h4Headline.copyWith(color: Colors.white),
        ),
        const SizedBox(height: 12),
        _InfoLabel(
          title: '운동장소',
          data: workoutPlace ?? '-',
        ),
        const SizedBox(height: 12),
        _InfoLabel(
          title: '희망요일',
          data: preferWorkoutDays.isNotEmpty
              ? preferWorkoutDays.join(' ∙ ')
              : '-',
        ),
      ],
    );
  }

  Column _bodySpecSection(UserDetailModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '신체정보',
          style: h4Headline.copyWith(color: Colors.white),
        ),
        const SizedBox(height: 12),
        _InfoLabel(
          title: '키',
          data: model.height != null ? model.height.toString() : '-',
          child: Positioned(
            bottom: 15,
            right: 20,
            child: Text(
              'cm',
              style: s2SubTitle.copyWith(color: Pallete.gray),
            ),
          ),
        ),
        const SizedBox(height: 12),
        _InfoLabel(
          title: '몸무게',
          data: model.weight != null ? model.weight.toString() : '-',
          child: Positioned(
            bottom: 15,
            right: 20,
            child: Text(
              'kg',
              style: s2SubTitle.copyWith(color: Pallete.gray),
            ),
          ),
        ),
        const SizedBox(height: 12),
        _InfoLabel(
          title: '생년월일',
          data: DataUtils.getDateString(model.birth),
          child: Positioned(
              bottom: 15,
              right: 20,
              child: SvgPicture.asset(SVGConstants.calendar, width: 20)),
        ),
      ],
    );
  }
}

class _SurveyContainer extends StatelessWidget {
  final String title;
  final Widget child;

  const _SurveyContainer({
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Pallete.darkGray,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 13,
          vertical: 10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: s2SubTitle.copyWith(color: Pallete.lightGray),
            ),
            const SizedBox(
              height: 8,
            ),
            child,
          ],
        ),
      ),
    );
  }
}

class _InfoLabel extends StatefulWidget {
  final String title;
  final String data;
  final Widget? child;

  const _InfoLabel({
    required this.title,
    required this.data,
    this.child,
  });

  @override
  State<_InfoLabel> createState() => _InfoLabelState();
}

class _InfoLabelState extends State<_InfoLabel> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 1,
          child: Text(
            widget.title,
            style: s2SubTitle.copyWith(color: Pallete.lightGray),
          ),
        ),
        Expanded(
          flex: 3,
          child: Stack(
            children: [
              Container(
                height: 44,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 1, color: Pallete.darkGray),
                ),
                child: Center(
                  child: Text(
                    widget.data,
                    style: s1SubTitle.copyWith(color: Colors.white),
                  ),
                ),
              ),
              if (widget.child != null) widget.child!,
            ],
          ),
        ),
      ],
    );
  }
}

class _Profile extends StatelessWidget {
  const _Profile({
    required this.model,
  });

  final UserDetailModel model;

  @override
  Widget build(BuildContext context) {
    return Center(
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
    );
  }
}
