// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tracking_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TrackingSessionImpl _$$TrackingSessionImplFromJson(
        Map<String, dynamic> json) =>
    _$TrackingSessionImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      locations: (json['locations'] as List<dynamic>)
          .map((e) => Location.fromJson(e as Map<String, dynamic>))
          .toList(),
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] == null
          ? null
          : DateTime.parse(json['endTime'] as String),
      totalDistance: (json['totalDistance'] as num?)?.toDouble() ?? 0.0,
      averageSpeed: (json['averageSpeed'] as num?)?.toDouble() ?? 0.0,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$TrackingSessionImplToJson(
        _$TrackingSessionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'locations': instance.locations,
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime?.toIso8601String(),
      'totalDistance': instance.totalDistance,
      'averageSpeed': instance.averageSpeed,
      'metadata': instance.metadata,
    };
