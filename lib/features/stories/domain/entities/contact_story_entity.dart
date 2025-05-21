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

  int get firstUnviewedStoryIndex {
    int index = stories.indexWhere((story) => story.isViewed == false);
    if (index == -1) {
      return 0;
    } else {
      return index;
    }
  }

  bool isStoryViewedAtIndex(int index) {
    if (index < 0 || index >= stories.length) return false;
    return stories[index].isViewed == true;
  }

  int getStoryIndexById(int storyId) {
    return stories.indexWhere((story) => story.id == storyId);
  }

  ContactStoryEntity copyWith({
    int? contactId,
    String? name,
    String? profileImage,
    List<StoryEntity>? stories,
  }) {
    return ContactStoryEntity(
      contactId: contactId ?? this.contactId,
      name: name ?? this.name,
      profileImage: profileImage ?? this.profileImage,
      stories: stories ?? this.stories,
    );
  }
}
