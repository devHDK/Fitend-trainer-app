import 'package:fitend_trainer_app/trainer/model/trainer_model.dart';
import 'package:fitend_trainer_app/trainer/provider/get_me_provider.dart';
import 'package:fitend_trainer_app/user/model/get_user_list_model.dart';
import 'package:fitend_trainer_app/user/model/user_list_model.dart';
import 'package:fitend_trainer_app/user/repository/user_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userListProvider =
    StateNotifierProvider.autoDispose<UserListStateNotifier, UserListModelBase>(
        (ref) {
  final repository = ref.watch(userRepositoryProvider);
  final trainer = ref.watch(getMeProvider) as TrainerModel;

  return UserListStateNotifier(
    repository: repository,
    trainer: trainer,
  );
});

class UserListStateNotifier extends StateNotifier<UserListModelBase> {
  final UserRepository repository;
  final TrainerModel trainer;

  UserListStateNotifier({
    required this.repository,
    required this.trainer,
  }) : super(UserListModelLoading()) {
    paginate();
  }

  Future<void> paginate({
    int? start = 0,
    String? search,
    bool fetchMore = false,
    bool isRefetch = false,
  }) async {
    try {
      final isRefetching = state is UserListModelRefetching;
      final isFetchMore = state is UserListModelFetchingMore;

      if (fetchMore && (isFetchMore || isRefetching)) {
        return;
      }

      if (fetchMore) {
        // 데이터를 추가로 가져오는 상황
        final pState = state as UserListModel;

        state = UserListModelFetchingMore(
          data: pState.data,
          total: pState.total,
        );
      } else {
        if (state is UserListModel) {
          final pState = state as UserListModel;
          state =
              UserListModelRefetching(data: pState.data, total: pState.total);
        }
      }

      final ret = await repository.getUsers(
          model: GetUserListModel(
        start: start!,
        status: 'active',
        perPage: 20,
        search: search,
        trainerId: trainer.trainer.id,
      ));

      if (state is UserListModelFetchingMore) {
        final pState = state as UserListModel;

        state = pState.copyWith(
          data: [
            ...pState.data,
            ...ret.data,
          ],
        );
      } else {
        state = ret;
      }
    } catch (e) {
      debugPrint('$e');

      state = UserListModelError(message: '데이터를 불러오지 못했습니다.');
    }
  }
}
