import 'package:whatsapp/features/stories/domain/entities/story_entity.dart';

class ContactStoryEntity {
  final int contactId;
  final String name;
  final String? profileImage;
  final List<StoryEntity> stories;

  ContactStoryEntity({
    required this.contactId,
    required this.name,
    required this.profileImage,
    required this.stories,
  });

  int get totalStoriesCount => stories.length;

  int get viewedStoriesCount =>
      stories.where((story) => story.isViewed == true).length;

  int get unviewedStoriesCount =>
      stories.where((story) => story.isViewed == false).length;
}
