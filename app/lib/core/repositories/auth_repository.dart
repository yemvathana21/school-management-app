import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:psbu_app/core/network/dio_client.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.read(dioClientProvider));
});

class AuthRepository {
  final DioClient _client;
  AuthRepository(this._client);

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await _client.dio.post('/login', data: {
      'email': email,
      'password': password,
    });
    return response.data as Map<String, dynamic>;
  }

  Future<void> logout() async {
    await _client.dio.post('/logout');
  }

  Future<Map<String, dynamic>> getUser() async {
    final response = await _client.dio.get('/user');
    return response.data as Map<String, dynamic>;
  }
}
