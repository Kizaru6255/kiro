/// Profile repository implementation (data layer).
library;

import 'package:dio/dio.dart';
import '../../domain/entities/user_profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../../../core/errors/errors.dart';
import '../datasources/profile_remote_datasource.dart';
import '../datasources/profile_local_datasource.dart';
import '../models/user_profile_dto.dart';

/// Implementation of profile repository.
class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;
  final ProfileLocalDataSource _localDataSource;

  ProfileRepositoryImpl({
    required ProfileRemoteDataSource remoteDataSource,
    required ProfileLocalDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  @override
  Future<Result<UserProfileEntity>> getProfile() async {
    try {
      final response = await _remoteDataSource.getProfile();

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        final dto = UserProfileDto.fromJson(
          data['profile'] as Map<String, dynamic>,
        );
        final entity = dto.toEntity();

        // Cache profile
        _localDataSource.cacheProfile(data['profile'] as Map<String, dynamic>);

        return Result.success(entity);
      } else {
        // Try cache on network failure
        return _getFromCache();
      }
    } on DioException {
      return _getFromCache();
    } catch (_) {
      return _getFromCache();
    }
  }

  Future<Result<UserProfileEntity>> _getFromCache() async {
    try {
      final cached = await _localDataSource.getCachedProfile();
      if (cached != null) {
        final dto = UserProfileDto.fromJson(cached);
        return Result.success(dto.toEntity());
      }
      return Result.failure(
        Failure.network(message: 'No cached profile available'),
      );
    } catch (e) {
      return Result.failure(
        Failure.network(message: 'Failed to get profile: $e'),
      );
    }
  }

  @override
  Future<Result<UserProfileEntity>> updateProfile({
    String? displayName,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? bio,
    DateTime? dateOfBirth,
    String? gender,
    String? address,
    String? city,
    String? state,
    String? country,
    String? zipCode,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (displayName != null) data['display_name'] = displayName;
      if (firstName != null) data['first_name'] = firstName;
      if (lastName != null) data['last_name'] = lastName;
      if (phoneNumber != null) data['phone_number'] = phoneNumber;
      if (bio != null) data['bio'] = bio;
      if (dateOfBirth != null) {
        data['date_of_birth'] = dateOfBirth.toIso8601String();
      }
      if (gender != null) data['gender'] = gender;
      if (address != null) data['address'] = address;
      if (city != null) data['city'] = city;
      if (state != null) data['state'] = state;
      if (country != null) data['country'] = country;
      if (zipCode != null) data['zip_code'] = zipCode;

      final response = await _remoteDataSource.updateProfile(data);

      if (response.statusCode == 200 && response.data != null) {
        final responseData = response.data as Map<String, dynamic>;
        final dto = UserProfileDto.fromJson(
          responseData['profile'] as Map<String, dynamic>,
        );
        final entity = dto.toEntity();

        // Update cache
        _localDataSource.cacheProfile(responseData['profile'] as Map<String, dynamic>);

        return Result.success(entity);
      } else {
        return Result.failure(
          Failure.network(
            message: 'Failed to update profile: ${response.statusMessage ?? 'Unknown error'}',
            statusCode: response.statusCode,
          ),
        );
      }
    } on DioException catch (e) {
      return Result.failure(
        Failure.network(
          message: e.message ?? 'Failed to update profile',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Result.failure(
        Failure.network(message: 'Failed to update profile: $e'),
      );
    }
  }

  @override
  Future<Result<String>> uploadProfilePicture(String imagePath) async {
    try {
      final response = await _remoteDataSource.uploadProfilePicture(imagePath);

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        final photoUrl = data['photo_url'] as String? ?? '';
        return Result.success(photoUrl);
      } else {
        return Result.failure(
          Failure.network(
            message: 'Failed to upload profile picture: ${response.statusMessage ?? 'Unknown error'}',
            statusCode: response.statusCode,
          ),
        );
      }
    } on DioException catch (e) {
      return Result.failure(
        Failure.network(
          message: e.message ?? 'Failed to upload profile picture',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Result.failure(
        Failure.network(message: 'Failed to upload profile picture: $e'),
      );
    }
  }
}
