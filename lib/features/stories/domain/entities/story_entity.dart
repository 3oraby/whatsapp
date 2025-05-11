import 'package:whatsapp/features/stories/domain/entities/react_story_entity.dart';
import 'package:whatsapp/features/stories/domain/entities/view_story_entity.dart';

class StoryEntity {
  final int id;
  final String content;
  final String? mediaUrl;
  final bool isActive;
  final DateTime expiredAt;
  final DateTime createdAt;
  final bool? isViewed;
  final List<ViewStoryEntity>? views;
  final List<ReactStoryEntity>? reacts;

  const StoryEntity({
    required this.id,
    required this.content,
    required this.mediaUrl,
    required this.isActive,
    required this.expiredAt,
    required this.createdAt,
    this.isViewed,
    this.views,
    this.reacts,
  });
}
