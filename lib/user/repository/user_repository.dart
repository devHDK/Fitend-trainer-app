import 'package:dio/dio.dart' hide Headers;
import 'package:fitend_trainer_app/common/dio/dio.dart';
import 'package:fitend_trainer_app/user/model/get_user_list_model.dart';
import 'package:fitend_trainer_app/user/model/user_list_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/retrofit.dart';

part 'user_repository.g.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final dio = ref.watch(dioProvider);

  return UserRepository(dio);
});

@RestApi()
abstract class UserRepository {
  factory UserRepository(Dio dio) = _UserRepository;

  @GET('/users')
  @Headers({
    'accessToken': 'true',
  })
  Future<UserListModel> getUsers({
    @Queries() required GetUserListModel model,
  });
}
