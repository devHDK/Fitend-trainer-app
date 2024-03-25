import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fitend_trainer_app/common/const/data_constants.dart';
import 'package:fitend_trainer_app/common/secure_storage/secure_storage.dart';
import 'package:fitend_trainer_app/common/utils/update_checker.dart';
import 'package:fitend_trainer_app/trainer/model/put_fcm_token.dart';
import 'package:fitend_trainer_app/trainer/model/trainer_model.dart';
import 'package:fitend_trainer_app/trainer/repository/auth_repository.dart';
import 'package:fitend_trainer_app/trainer/repository/get_me_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';

final getMeProvider =
    StateNotifierProvider<GetMeStateNotifier, TrainerModelBase?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final getMeRepository = ref.watch(getMeRepositoryProvider);
  final storage = ref.watch(secureStorageProvider);

  return GetMeStateNotifier(
    authRepository: authRepository,
    repository: getMeRepository,
    storage: storage,
  );
});

Future<Map<String, dynamic>> getStoreVersionInfo() async {
  final packageInfo = await PackageInfo.fromPlatform();
  final version = packageInfo.version;
  final storeVersion = await checkUpdatable(version);

  return storeVersion;

  // return Future.value(storeVersion);
}

Future<Map<String, dynamic>?> checkStoreVersion() async {
  final storeVersion = await getStoreVersionInfo();
  return storeVersion;
}

class GetMeStateNotifier extends StateNotifier<TrainerModelBase?> {
  final AuthRepository authRepository;
  final GetMeRepository repository;
  final FlutterSecureStorage storage;

  GetMeStateNotifier({
    required this.authRepository,
    required this.repository,
    required this.storage,
  }) : super(TrainerModelLoading()) {
    getMe();
  }

  Future<void> getMe() async {
    try {
      checkStoreVersion().then((storeVersion) async {
        debugPrint('$storeVersion');
        if (storeVersion != null) {
          bool isNeedStoreUpdate = storeVersion['needUpdate'];
          if (isNeedStoreUpdate) {
            //sotre 연결
            state = TrainerModelError(
                error: 'store version error', statusCode: 444);
          } else {
            final refreshToken =
                await storage.read(key: StringConstants.refreshToken);
            final accessToken =
                await storage.read(key: StringConstants.accessToken);

            if (refreshToken == null || accessToken == null) {
              state = null;
              return;
            }

            final response = await repository.getMe();

            final diviceId = await _getDeviceInfo();
            final token = await FirebaseMessaging.instance.getToken();

            debugPrint('diviceId : $diviceId');
            debugPrint('fcm token : $token');

            await repository.putFCMToken(
                putFcmToken: PutFcmToken(
              deviceId: diviceId,
              token: token!,
              platform: Platform.isIOS ? 'ios' : 'android',
            ));

            state = response;
          }
        }
      });
    } on DioException catch (e) {
      if (e.type == DioExceptionType.unknown) {
        state = TrainerModelError(error: 'connection error', statusCode: 504);
      }

      if (e.response != null && e.response!.statusCode == 500) {
        state = null;

        await logout();

        state = TrainerModelError(error: 'token error', statusCode: 500);
      }
    }
  }

  Future<TrainerModelBase> login({
    required String email,
    required String password,
    required String platform,
    required String token,
    required String deviceId,
  }) async {
    try {
      state = TrainerModelLoading();

      final resp = await authRepository.login(
        email: email,
        password: password,
        platform: platform,
        token: token,
        deviceId: deviceId,
      );

      await storage.write(
          key: StringConstants.refreshToken, value: resp.refreshToken);
      await storage.write(
          key: StringConstants.accessToken, value: resp.accessToken);

      final userResp = await repository.getMe();

      state = userResp.copyWith();

      return userResp;
    } on DioException catch (e) {
      if (e.response != null) {
        if (e.response!.statusCode != null) {
          if (e.response!.statusCode! == 404 ||
              e.response!.statusCode! == 400) {
            state = TrainerModelError(
              error: '해당 이메일로 가입된 계정이 없어요 😅',
              statusCode: e.response!.statusCode!,
            );
          } else if (e.response!.statusCode! == 409) {
            state = TrainerModelError(
              error: '이메일 또는 비밀번호가 맞지 않아요 😭',
              statusCode: e.response!.statusCode!,
            );
          } else if (e.response!.statusCode! == 403) {
            state = TrainerModelError(
              error: '사용할 수 없는 계정입니다. 관리자에게 문의해 주세요!',
              statusCode: e.response!.statusCode!,
            );
          } else {
            state = TrainerModelError(
              error: '알수없는 에러입니다.',
              statusCode: e.response!.statusCode!,
            );
          }
        }
      }

      return Future.value(state);
    }
  }

  Future<void> logout() async {
    try {
      final deviceId = await _getDeviceInfo();

      await authRepository.logout(
        deviceId: deviceId,
        platform: Platform.isAndroid ? 'android' : 'ios',
      );

      await Future.wait([
        storage.delete(key: StringConstants.refreshToken),
        storage.delete(key: StringConstants.accessToken),
      ]);
    } catch (e) {
      debugPrint('$e');
    }

    state = null;
  }

  Future<String> _getDeviceInfo() async {
    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      IosDeviceInfo? iosInfo;
      String? androidUuid;

      if (Platform.isAndroid) {
        final savedUuid = await storage.read(key: StringConstants.deviceId);

        androidUuid = savedUuid;

        debugPrint('deviceId : $androidUuid');
      } else if (Platform.isIOS) {
        iosInfo = await deviceInfo.iosInfo;
        debugPrint('deviceId : ${iosInfo.identifierForVendor!}');
      }

      return Platform.isAndroid ? androidUuid! : iosInfo!.identifierForVendor!;
    } catch (e) {
      debugPrint('_getDeviceInfo error ===> $e');
      await Future.wait([
        storage.delete(key: StringConstants.refreshToken),
        storage.delete(key: StringConstants.accessToken),
      ]);
      state = null;

      return '';
    }
  }

  void changeIsNotification({
    required bool isNotification,
  }) {
    final pstate = state as TrainerModel;

    state = pstate.copyWith(
      trainer: pstate.trainer.copyWith(isNotification: isNotification),
    );
  }
}
