import 'package:whatsapp/features/stories/domain/entities/contact_story_entity.dart';

class UserContactsStoryEntity {
  final List<ContactStoryEntity> viewedContacts;
  final List<ContactStoryEntity> unViewedContacts;

  UserContactsStoryEntity({
    required this.viewedContacts,
    required this.unViewedContacts,
  });
}
