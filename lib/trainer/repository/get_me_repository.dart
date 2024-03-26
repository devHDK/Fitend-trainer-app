import 'package:dio/dio.dart' hide Headers;
import 'package:fitend_trainer_app/common/dio/dio.dart';
import 'package:fitend_trainer_app/trainer/model/put_fcm_token.dart';
import 'package:fitend_trainer_app/trainer/model/trainer_detail_model.dart';
import 'package:fitend_trainer_app/trainer/model/trainer_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/retrofit.dart';

part 'get_me_repository.g.dart';

final getMeRepositoryProvider = Provider<GetMeRepository>((ref) {
  final dio = ref.watch(dioProvider);

  return GetMeRepository(dio);
});

@RestApi()
abstract class GetMeRepository {
  factory GetMeRepository(Dio dio) = _GetMeRepository;

  @GET('/trainers/getMe')
  @Headers({
    'accessToken': 'true',
  })
  Future<TrainerModel> getMe();

  @GET('/trainers/detail')
  @Headers({
    'accessToken': 'true',
  })
  Future<TrainerDetailModel> getTrainerDetail();

  @PUT('/trainers/fcmToken')
  @Headers({
    'accessToken': 'true',
  })
  Future<void> putFCMToken({
    @Body() required PutFcmToken putFcmToken,
  });
}
