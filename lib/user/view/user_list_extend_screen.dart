import 'package:fitend_trainer_app/common/component/custom_network_image.dart';
import 'package:fitend_trainer_app/common/component/custom_text_form_field.dart';
import 'package:fitend_trainer_app/common/const/aseet_constants.dart';
import 'package:fitend_trainer_app/common/const/data_constants.dart';
import 'package:fitend_trainer_app/common/const/pallete.dart';
import 'package:fitend_trainer_app/common/const/text_style.dart';
import 'package:fitend_trainer_app/user/model/user_list_model.dart';
import 'package:fitend_trainer_app/user/provider/user_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:rxdart/rxdart.dart';

class UserListExtendScreen extends ConsumerStatefulWidget {
  const UserListExtendScreen({
    super.key,
  });

  @override
  ConsumerState<UserListExtendScreen> createState() =>
      _UserListExtendScreenState();
}

class _UserListExtendScreenState extends ConsumerState<UserListExtendScreen> {
  final _searchController = TextEditingController();
  final BehaviorSubject<String> _subject = BehaviorSubject<String>();
  final ScrollController _scrollController = ScrollController();

  bool isLoading = false;
  int start = 0;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchTextChanged);
    _subject.stream
        .debounceTime(const Duration(milliseconds: 800))
        .listen(refetch);
    _scrollController.addListener(listener);
  }

  void _onSearchTextChanged() {
    _subject.add(_searchController.text);
  }

  void refetch(String text) {
    debugPrint("search ===> $text");
    if (text.isNotEmpty) {
      ref.read(userListProvider.notifier).paginate(
            isRefetch: true,
            search: text,
          );
    } else {
      ref.read(userListProvider.notifier).paginate(
            isRefetch: true,
          );
    }
  }

  void listener() async {
    if (mounted) {
      final provider = ref.read(userListProvider.notifier);
      final pstate = ref.read(userListProvider);

      if (_scrollController.offset >
              _scrollController.position.maxScrollExtent - 100 &&
          pstate is UserListModel &&
          pstate.data.length < pstate.total) {
        //스크롤을 아래로 내렸을때
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
          await provider.paginate(start: pstate.data.length, fetchMore: true);
        });
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(listener);
    _searchController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(userListProvider);

    if (state is UserListModelError) {
      if (_searchController.text.isNotEmpty) {
        ref.read(userListProvider.notifier).paginate(
              isRefetch: true,
              search: _searchController.text,
            );
      } else {
        ref.read(userListProvider.notifier).paginate(
              isRefetch: true,
            );
      }
    }

    return Scaffold(
      backgroundColor: Pallete.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Pallete.background,
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: IconButton(
              onPressed: () {
                context.pop();
              },
              icon: const Icon(
                Icons.close_sharp,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
      body: Padding(
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
            if (state is UserListModelLoading)
              const Center(
                child: CircularProgressIndicator(
                  color: Pallete.point,
                ),
              )
            else
              Expanded(
                child: ListView.separated(
                  separatorBuilder: (context, index) => const SizedBox(
                    height: 25,
                  ),
                  controller: _scrollController,
                  itemBuilder: (context, index) {
                    final pstate = state as UserListModel;
                    start = pstate.data.length;

                    if (index == pstate.data.length &&
                        state.data.length < state.total) {
                      return const SizedBox(
                        height: 48,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Pallete.point,
                          ),
                        ),
                      );
                    } else if (index == pstate.data.length &&
                        state.data.length == state.total) {
                      return const SizedBox();
                    }

                    final model = pstate.data[index];

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
                        context.pop(
                            {"nickname": model.nickname, "userId": model.id});
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
                          ],
                        ),
                      ),
                    );
                  },
                  itemCount: state is UserListModel ? state.data.length + 1 : 0,
                ),
              )
          ],
        ),
      ),
    );
  }
}
