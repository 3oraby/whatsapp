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
}
