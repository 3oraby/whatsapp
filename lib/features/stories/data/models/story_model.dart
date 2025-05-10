import 'package:whatsapp/features/stories/data/models/react_story_model.dart';
import 'package:whatsapp/features/stories/data/models/view_story_model.dart';
import 'package:whatsapp/features/stories/domain/entities/react_story_entity.dart';
import 'package:whatsapp/features/stories/domain/entities/story_entity.dart';
import 'package:whatsapp/features/stories/domain/entities/view_story_entity.dart';

class StoryModel extends StoryEntity {
  const StoryModel({
    required super.id,
    required super.content,
    required super.mediaUrl,
    required super.isActive,
    required super.expiredAt,
    required super.createdAt,
    super.isViewed,
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
        isViewed: json['isViewed'],
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
        'isViewed': isViewed,
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
        views: views,
        reacts: reacts,
      );

  StoryModel copyWith({
    int? id,
    String? content,
    String? mediaUrl,
    bool? isActive,
    DateTime? expiredAt,
    DateTime? createdAt,
    bool? isViewed,
    List<ViewStoryEntity>? views,
    List<ReactStoryEntity>? reacts,
  }) =>
      StoryModel(
        id: id ?? this.id,
        content: content ?? this.content,
        mediaUrl: mediaUrl ?? this.mediaUrl,
        isActive: isActive ?? this.isActive,
        expiredAt: expiredAt ?? this.expiredAt,
        createdAt: createdAt ?? this.createdAt,
        isViewed: isViewed ?? this.isViewed,
        views: views ?? this.views,
        reacts: reacts ?? this.reacts,
      );
}
