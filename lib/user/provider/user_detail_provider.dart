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
      final ret = await repository.getUserDetail(id: id);
      state = ret;
    } catch (e) {
      state = UserDetailModelError(message: '$e');
    }
  }
}
