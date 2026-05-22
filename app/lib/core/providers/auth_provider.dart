import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:psbu_app/core/constants.dart';
import 'package:psbu_app/core/models/user_model.dart';
import 'package:psbu_app/core/repositories/auth_repository.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthState {
  final AuthStatus status;
  final UserModel? user;
  final String? token;
  final String? error;

  const AuthState({
    this.status = AuthStatus.unknown,
    this.user,
    this.token,
    this.error,
  });

  AuthState copyWith({
    AuthStatus? status,
    UserModel? user,
    String? token,
    String? error,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      token: token ?? this.token,
      error: error,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;
  final FlutterSecureStorage _storage;

  AuthNotifier(this._repository, this._storage) : super(const AuthState()) {
    _loadSavedAuth();
  }

  Future<void> _loadSavedAuth() async {
    try {
      final token = await _storage.read(key: AppConstants.tokenKey);
      final userData = await _storage.read(key: AppConstants.userKey);
      if (token != null && userData != null) {
        final user = UserModel.fromJson(
          jsonDecode(userData) as Map<String, dynamic>,
        );
        state = AuthState(
          status: AuthStatus.authenticated,
          user: user,
          token: token,
        );
      } else {
        state = const AuthState(status: AuthStatus.unauthenticated);
      }
    } catch (_) {
      state = const AuthState(status: AuthStatus.unauthenticated);
    }
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(error: null);
    try {
      final data = await _repository.login(email, password);
      final token = data['token'] as String;
      final user = UserModel.fromJson(data['user'] as Map<String, dynamic>);
      await _storage.write(key: AppConstants.tokenKey, value: token);
      await _storage.write(
        key: AppConstants.userKey,
        value: jsonEncode(user.toJson()),
      );
      state = AuthState(
        status: AuthStatus.authenticated,
        user: user,
        token: token,
      );
    } catch (e) {
      state = state.copyWith(error: 'Login failed. Check your credentials.');
    }
  }

  Future<void> logout() async {
    try {
      await _repository.logout();
    } catch (_) {}
    await _storage.delete(key: AppConstants.tokenKey);
    await _storage.delete(key: AppConstants.userKey);
    state = const AuthState(status: AuthStatus.unauthenticated);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    ref.read(authRepositoryProvider),
    const FlutterSecureStorage(),
  );
});
