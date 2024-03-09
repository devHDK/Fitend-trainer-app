import 'package:fitend_trainer_app/common/model/get_pagenate_model.dart';
import 'package:fitend_trainer_app/user/model/user_detail_model.dart';
import 'package:fitend_trainer_app/user/repository/user_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userDetailProvider = StateNotifierProviderFamily<UserListStateNotifier,
    UserDetailModelBase, int>((ref, id) {
  final repository = ref.watch(userRepositoryProvider);

  return UserListStateNotifier(
    repository: repository,
    id: id,
  );
});

class UserListStateNotifier extends StateNotifier<UserDetailModelBase> {
  final UserRepository repository;
  final int id;

  UserListStateNotifier({
    required this.repository,
    required this.id,
  }) : super(UserDetailModelLoading()) {
    init();
  }

  Future<void> init() async {
    try {
      UserDetailModel ret = await repository.getUserDetail(id: id);
      final bodySpecList = await repository.getUserBodySpec(
          id: id, pagenateModel: GetPagenateModel(start: 0, perPage: 5));

      double? weight;
      double? height;

      if (bodySpecList.data.isNotEmpty) {
        weight = bodySpecList.data.first.weight;
        height = bodySpecList.data.first.height;
      }

      state = ret.copyWith(weight: weight, height: height);
    } catch (e) {
      state = UserDetailModelError(message: '$e');
    }
  }
}
