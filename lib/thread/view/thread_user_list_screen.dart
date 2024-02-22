import 'package:fitend_trainer_app/common/component/custom_network_image.dart';
import 'package:fitend_trainer_app/common/component/custom_text_form_field.dart';
import 'package:fitend_trainer_app/common/const/aseet_constants.dart';
import 'package:fitend_trainer_app/common/const/data_constants.dart';
import 'package:fitend_trainer_app/common/const/pallete.dart';
import 'package:fitend_trainer_app/common/const/text_style.dart';
import 'package:fitend_trainer_app/common/utils/data_utils.dart';
import 'package:fitend_trainer_app/thread/model/common/thread_user_model.dart';
import 'package:fitend_trainer_app/thread/model/userlist/thread_user_list_model.dart';
import 'package:fitend_trainer_app/thread/provider/thread_user_list_provider.dart';
import 'package:fitend_trainer_app/thread/view/thread_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class ThreadUserListScreen extends ConsumerStatefulWidget {
  const ThreadUserListScreen({
    super.key,
  });

  @override
  ConsumerState<ThreadUserListScreen> createState() =>
      ThreadUserListScreenState();
}

class ThreadUserListScreenState extends ConsumerState<ThreadUserListScreen> {
  final _searchController = TextEditingController();
  // final BehaviorSubject<String> _subject = BehaviorSubject<String>();
  final ScrollController _scrollController = ScrollController();

  bool isLoading = false;
  int start = 0;

  @override
  void initState() {
    super.initState();
    // _searchController.addListener(_onSearchTextChanged);
    // _subject.stream
    //     .debounceTime(const Duration(milliseconds: 500))
    //     .listen(refetch);
  }

  // void _onSearchTextChanged() {
  //   _subject.add(_searchController.text);
  // }

  // void refetch(String text) {
  //   debugPrint("search ===> $text");

  //   ref.read(threadUserListProvider.notifier).getThreadUsers(
  //         search: text,
  //       );
  // }

  @override
  void dispose() {
    _searchController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(threadUserListProvider);

    if (state is ThreadUserListModelLoading ||
        state is ThreadUserListModelError) {
      return const Center(
          child: CircularProgressIndicator(
        color: Pallete.point,
      ));
    }

    final userListModel = state as ThreadUserListModel;
    final filteredModel = userListModel.data
        .where((element) => element.nickname.contains(_searchController.text))
        .toList();

    return userListModel.data.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Stack(
                  children: [
                    CustomTextFormField(
                      onChanged: (value) {
                        _searchController.text = value;
                        setState(() {});
                      },
                      controller: _searchController,
                      fullLabelText:
                          _searchController.text.isNotEmpty ? '' : '이름으로 검색',
                      labelText: '',
                      contentPadding: 50,
                      mainColor: Pallete.darkGray,
                      textColor: Pallete.gray,
                    ),
                    Positioned(
                      top: 11,
                      left: 11,
                      child: SvgPicture.asset(SVGConstants.search),
                    )
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                Expanded(
                  child: RefreshIndicator(
                    backgroundColor: Pallete.background,
                    color: Pallete.point,
                    semanticsLabel: '새로고침',
                    onRefresh: () async {
                      await ref
                          .read(threadUserListProvider.notifier)
                          .getThreadUsers();
                    },
                    child: ListView.separated(
                      separatorBuilder: (context, index) => const SizedBox(
                        height: 25,
                      ),
                      controller: _scrollController,
                      itemBuilder: (context, index) {
                        final model = filteredModel[index];

                        String ticketType = '';

                        if (model.availableTickets == null ||
                            model.availableTickets!.isEmpty) {
                          ticketType = '이용중인 상품 없음';
                        } else {
                          final ticket = model.availableTickets!.first;
                          final remainDate =
                              ticket.expiredAt.difference(DateTime.now());

                          if (ticket.type == 'personal') {
                            ticketType = 'PT ∙ ${remainDate.inDays}일 남음';
                          } else if (ticket.month == 0) {
                            ticketType = '무료체험 ∙ ${remainDate.inDays}일 남음';
                          } else {
                            ticketType =
                                '${ticket.month}개월권 ∙ ${remainDate.inDays}일 남음';
                          }
                        }

                        return GestureDetector(
                          onTap: () {
                            ref
                                .read(threadUserListProvider.notifier)
                                .updateIsChecked(model.id);

                            Navigator.of(context).push(
                              CupertinoPageRoute(
                                builder: (context) => ThreadScreen(
                                  user: ThreadUser(
                                    id: model.id,
                                    nickname: model.nickname,
                                    gender: model.gender,
                                  ),
                                  titleContent: ticketType,
                                ),
                              ),
                            );
                          },
                          child: SizedBox(
                            height: 50,
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(24),
                                  child: CustomNetworkImage(
                                    imageUrl: model.gender == 'male'
                                        ? URLConstants.maleProfileUrl
                                        : URLConstants.femaleProfileUrl,
                                    width: 48,
                                    height: 48,
                                    boxFit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      model.nickname,
                                      style: h4Headline.copyWith(
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      ticketType,
                                      style: s2SubTitle.copyWith(
                                        color: Pallete.lightGray,
                                      ),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                Stack(
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        if (model.updatedAt != null)
                                          Text(
                                            DataUtils
                                                .getElapsedTimeStringFromNow(
                                                    model.updatedAt!),
                                            style: c1Caption.copyWith(
                                              color: Pallete.gray,
                                            ),
                                          ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                    if (!model.isChecked)
                                      Positioned(
                                        right: 1,
                                        bottom: 10,
                                        child: SvgPicture.asset(
                                            SVGConstants.redDot),
                                      ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      },
                      itemCount: filteredModel.length,
                    ),
                  ),
                )
              ],
            ),
          )
        : Center(
            child: Text(
              '아직 매칭된 회원이 없어요 😅',
              style: s1SubTitle.copyWith(color: Colors.white),
            ),
          );
  }

  void tapTop() {
    ref.read(threadUserListProvider.notifier).getThreadUsers();
  }
}
