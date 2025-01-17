import 'package:dio/dio.dart' hide Headers;
import 'package:fitend_trainer_app/common/dio/dio.dart';
import 'package:fitend_trainer_app/common/model/get_pagenate_model.dart';
import 'package:fitend_trainer_app/user/model/get_user_list_model.dart';
import 'package:fitend_trainer_app/user/model/user_body_spec_list_model.dart';
import 'package:fitend_trainer_app/user/model/user_detail_model.dart';
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
  @GET('/users/{id}')
  @Headers({
    'accessToken': 'true',
  })
  Future<UserDetailModel> getUserDetail({
    @Path() required int id,
  });

  @GET('/users/{id}/bodySpec')
  @Headers({
    'accessToken': 'true',
  })
  Future<UserBodySpecList> getUserBodySpec({
    @Path() required int id,
    @Queries() required GetPagenateModel pagenateModel,
  });
}
