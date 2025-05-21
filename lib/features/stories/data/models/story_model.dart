import 'package:whatsapp/core/api/api_keys.dart';
import 'package:whatsapp/features/stories/data/models/react_story_model.dart';
import 'package:whatsapp/features/stories/data/models/view_story_model.dart';
import 'package:whatsapp/features/stories/domain/entities/story_entity.dart';

class StoryModel extends StoryEntity {
  const StoryModel({
    required super.id,
    super.content,
    required super.isActive,
    required super.expiredAt,
    required super.createdAt,
    super.mediaUrl,
    super.isViewed,
    super.isReacted,
    super.views,
    super.reacts,
  });

  factory StoryModel.fromJson(Map<String, dynamic> json) => StoryModel(
        id: json['id'],
        content: json['content'],
        mediaUrl: json['media_url'],
        isActive: json['isActive'],
        expiredAt: DateTime.parse(json['expired_at']),
        createdAt: DateTime.parse(json['createdAt']),
        isViewed: json[ApiKeys.isViewed],
        isReacted: json[ApiKeys.isReacted],
        views: (json['views'] as List?)
            ?.map((e) => ViewStoryModel.fromJson(e))
            .toList(),
        reacts: (json['reacts'] as List?)
            ?.map((e) => ReactStoryModel.fromJson(e))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'content': content,
        'media_url': mediaUrl,
        'isActive': isActive,
        'expired_at': expiredAt.toIso8601String(),
        'createdAt': createdAt.toIso8601String(),
        ApiKeys.isViewed: isViewed,
        ApiKeys.isReacted: isReacted,
        'views': views?.map((e) => (e as ViewStoryModel).toJson()).toList(),
        'reacts': reacts?.map((e) => (e as ReactStoryModel).toJson()).toList(),
      };

  factory StoryModel.fromEntity(StoryEntity entity) => StoryModel(
        id: entity.id,
        content: entity.content,
        mediaUrl: entity.mediaUrl,
        isActive: entity.isActive,
        expiredAt: entity.expiredAt,
        createdAt: entity.createdAt,
        isViewed: entity.isViewed,
        isReacted: entity.isReacted,
        views: entity.views,
        reacts: entity.reacts,
      );

  StoryEntity toEntity() => StoryEntity(
        id: id,
        content: content,
        mediaUrl: mediaUrl,
        isActive: isActive,
        expiredAt: expiredAt,
        createdAt: createdAt,
        isViewed: isViewed,
        isReacted: isReacted,
        views: views,
        reacts: reacts,
      );
}
