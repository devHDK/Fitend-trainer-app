import 'package:dio/dio.dart' hide Headers;
import 'package:fitend_trainer_app/common/dio/dio.dart';
import 'package:fitend_trainer_app/thread/model/get_thread_user_list_params.dart';
import 'package:fitend_trainer_app/thread/model/thread_user_list_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/retrofit.dart';

part 'thread_repository.g.dart';

final threadRepositoryProvider = Provider<ThreadRepository>((ref) {
  final dio = ref.watch(dioProvider);

  return ThreadRepository(dio);
});

@RestApi()
abstract class ThreadRepository {
  factory ThreadRepository(Dio dio) = _ThreadRepository;

  @GET('/threads/users')
  @Headers({
    'accessToken': 'true',
  })
  Future<ThreadUserListModel> getThreadUsers({
    @Queries() required GetThreadUserListParams model,
  });
}
