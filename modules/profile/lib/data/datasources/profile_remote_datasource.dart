/// Profile remote data source.
library;

import 'package:dio/dio.dart';

/// Remote data source for profile operations.
abstract class ProfileRemoteDataSource {
  /// Get current user profile.
  Future<Response<Map<String, dynamic>>> getProfile();

  /// Update profile.
  Future<Response<Map<String, dynamic>>> updateProfile(
    Map<String, dynamic> data,
  );

  /// Upload profile picture.
  Future<Response<Map<String, dynamic>>> uploadProfilePicture(
    String imagePath,
  );
}

/// Implementation of profile remote data source.
class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final Dio _dio;

  ProfileRemoteDataSourceImpl({
    Dio? dio,
  }) : _dio = dio ?? Dio();

  @override
  Future<Response<Map<String, dynamic>>> getProfile() async {
    return await _dio.get<Map<String, dynamic>>(
      '/profile',
    );
  }

  @override
  Future<Response<Map<String, dynamic>>> updateProfile(
    Map<String, dynamic> data,
  ) async {
    return await _dio.put<Map<String, dynamic>>(
      '/profile',
      data: data,
    );
  }

  @override
  Future<Response<Map<String, dynamic>>> uploadProfilePicture(
    String imagePath,
  ) async {
    // TODO: Implement file upload
    throw UnimplementedError('Profile picture upload not yet implemented');
  }
}
