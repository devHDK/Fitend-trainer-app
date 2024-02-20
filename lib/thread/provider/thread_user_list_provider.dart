import 'package:fitend_trainer_app/thread/model/get_thread_user_list_params.dart';
import 'package:fitend_trainer_app/thread/model/thread_user_list_model.dart';
import 'package:fitend_trainer_app/thread/repository/thread_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final threadUserListProvider = StateNotifierProvider.autoDispose<
    ThreadUserStateNotifier, ThreadUserListModelBase?>((ref) {
  final repository = ref.watch(threadRepositoryProvider);

  return ThreadUserStateNotifier(repository: repository);
});

class ThreadUserStateNotifier extends StateNotifier<ThreadUserListModelBase?> {
  final ThreadRepository repository;

  ThreadUserStateNotifier({
    required this.repository,
  }) : super(ThreadUserListModelLoading()) {
    getThreadUsers();
  }

  Future<void> getThreadUsers({String? search, String? order = 'DESC'}) async {
    try {
      state = ThreadUserListModelLoading();

      final model = await repository.getThreadUsers(
          model: GetThreadUserListParams(search: search, order: order!));

      state = model.copyWith();
    } catch (e) {
      debugPrint('$e');
      state = ThreadUserListModelError(message: e.toString());
    }
  }
}
