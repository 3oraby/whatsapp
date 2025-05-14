import 'package:whatsapp/features/stories/domain/entities/story_entity.dart';

class ContactStoryEntity {
  final int contactId;
  final String name;
  final String? profileImage;
  final List<StoryEntity> stories;

  ContactStoryEntity({
    required this.contactId,
    required this.name,
    required this.stories,
    this.profileImage,
  });

  int get totalStoriesCount => stories.length;

  int get viewedStoriesCount =>
      stories.where((story) => story.isViewed == true).length;

  int get unviewedStoriesCount =>
      stories.where((story) => story.isViewed == false).length;

  factory ContactStoryEntity.empty() {
    return ContactStoryEntity(
      contactId: -1,
      name: "",
      stories: [],
    );
  }

  bool get isEmpty => stories.isEmpty && contactId == -1;
  bool get isNotEmpty => !isEmpty;
}
