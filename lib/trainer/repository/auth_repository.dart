import 'package:dio/dio.dart';
import 'package:fitend_trainer_app/common/dio/dio.dart';
import 'package:fitend_trainer_app/common/secure_storage/secure_storage.dart';
import 'package:fitend_trainer_app/trainer/model/login_response.dart';
import 'package:fitend_trainer_app/trainer/model/token_response.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dio = ref.watch(dioProvider);
  final storage = ref.read(secureStorageProvider);

  return AuthRepository(dio: dio, storage: storage);
});

class AuthRepository {
  final Dio dio;
  final FlutterSecureStorage storage;

  AuthRepository({
    required this.dio,
    required this.storage,
  });

  Future<LoginResponse> login({
    required String email,
    required String password,
    required String platform,
    required String token,
    required String deviceId,
  }) async {
    final response = await dio.post(
      '/auth',
      data: {
        'email': email,
        'password': password,
        'platform': platform,
        'token': token,
        'deviceId': deviceId
      },
    );

    return LoginResponse.fromJson(response.data);
  }

  Future<void> logout({
    required String deviceId,
    required String platform,
  }) async {
    await dio.post(
      '/auth/logout',
      options: Options(
        headers: {
          'accessToken': 'true',
        },
      ),
      data: {
        'deviceId': deviceId,
        'platform': platform,
      },
    );
  }

  Future<TokenResponse> token() async {
    final response = await dio.post(
      '/auth/refresh',
      options: Options(
        headers: {
          'accessToken': 'true',
          'refreshToken': 'true',
        },
      ),
    );

    return TokenResponse.fromJson(response.data);
  }
}
