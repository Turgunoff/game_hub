import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/network/dio_client.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login({
    required String email,
    required String password,
  });

  Future<UserModel> register({
    required String email,
    required String password,
    required String username,
  });

  Future<void> logout();

  Future<UserModel> getCurrentUser();
}

@Singleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient dioClient;

  AuthRemoteDataSourceImpl(this.dioClient);

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await dioClient.post(
        'auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      return UserModel.fromJson(response.data['user']);
    } on DioException catch (e) {
      throw Exception('Login failed: ${e.message}');
    }
  }

  @override
  Future<UserModel> register({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      final response = await dioClient.post(
        'auth/register',
        data: {
          'email': email,
          'password': password,
          'username': username,
        },
      );

      return UserModel.fromJson(response.data['user']);
    } on DioException catch (e) {
      throw Exception('Registration failed: ${e.message}');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await dioClient.post('auth/logout');
    } on DioException catch (e) {
      throw Exception('Logout failed: ${e.message}');
    }
  }

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      final response = await dioClient.get('auth/me');
      return UserModel.fromJson(response.data['user']);
    } on DioException catch (e) {
      throw Exception('Failed to get current user: ${e.message}');
    }
  }
}