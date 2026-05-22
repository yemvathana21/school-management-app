import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:psbu_app/core/constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final dioClientProvider = Provider<DioClient>((ref) => DioClient());

class DioClient {
  late final Dio _dio;
  final _storage = const FlutterSecureStorage();

  DioClient() {
    _dio = Dio(BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Accept': 'application/json'},
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _storage.read(key: AppConstants.tokenKey);
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (error, handler) {
        handler.next(error);
      },
    ));
  }

  Dio get dio => _dio;

  Future<void> setToken(String token) async {
    await _storage.write(key: AppConstants.tokenKey, value: token);
  }

  Future<void> clearToken() async {
    await _storage.delete(key: AppConstants.tokenKey);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: AppConstants.tokenKey);
  }
}
