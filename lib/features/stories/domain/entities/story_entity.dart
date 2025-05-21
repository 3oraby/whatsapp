import 'package:whatsapp/features/stories/domain/entities/react_story_entity.dart';
import 'package:whatsapp/features/stories/domain/entities/view_story_entity.dart';

class StoryEntity {
  final int id;
  final String? content;
  final String? mediaUrl;
  final bool isActive;
  final DateTime expiredAt;
  final DateTime createdAt;
  final bool? isViewed;
  final bool? isReacted;
  final List<ViewStoryEntity>? views;
  final List<ReactStoryEntity>? reacts;

  const StoryEntity({
    required this.id,
    this.content,
    required this.mediaUrl,
    required this.isActive,
    required this.expiredAt,
    required this.createdAt,
    this.isViewed,
    this.isReacted,
    this.views,
    this.reacts,
  });

  StoryEntity copyWith({
    int? id,
    String? content,
    String? mediaUrl,
    bool? isActive,
    DateTime? expiredAt,
    DateTime? createdAt,
    bool? isViewed,
    bool? isReacted,
    List<ViewStoryEntity>? views,
    List<ReactStoryEntity>? reacts,
  }) =>
      StoryEntity(
        id: id ?? this.id,
        content: content ?? this.content,
        mediaUrl: mediaUrl ?? this.mediaUrl,
        isActive: isActive ?? this.isActive,
        expiredAt: expiredAt ?? this.expiredAt,
        createdAt: createdAt ?? this.createdAt,
        isViewed: isViewed ?? this.isViewed,
        isReacted: isReacted ?? this.isReacted,
        views: views ?? this.views,
        reacts: reacts ?? this.reacts,
      );
}
