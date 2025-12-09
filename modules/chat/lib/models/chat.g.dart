// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChatImpl _$$ChatImplFromJson(Map<String, dynamic> json) => _$ChatImpl(
      id: json['id'] as String,
      type: $enumDecode(_$ChatTypeEnumMap, json['type']),
      name: json['name'] as String,
      description: json['description'] as String?,
      imageUrl: json['imageUrl'] as String?,
      participantIds: (json['participantIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      lastMessage: json['lastMessage'] == null
          ? null
          : Message.fromJson(json['lastMessage'] as Map<String, dynamic>),
      unreadCount: (json['unreadCount'] as num?)?.toInt() ?? 0,
      lastActivityAt: json['lastActivityAt'] == null
          ? null
          : DateTime.parse(json['lastActivityAt'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$ChatImplToJson(_$ChatImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$ChatTypeEnumMap[instance.type]!,
      'name': instance.name,
      'description': instance.description,
      'imageUrl': instance.imageUrl,
      'participantIds': instance.participantIds,
      'lastMessage': instance.lastMessage,
      'unreadCount': instance.unreadCount,
      'lastActivityAt': instance.lastActivityAt?.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'metadata': instance.metadata,
    };

const _$ChatTypeEnumMap = {
  ChatType.direct: 'direct',
  ChatType.group: 'group',
};
