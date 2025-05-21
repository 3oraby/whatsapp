import 'dart:developer';

import 'package:whatsapp/features/stories/domain/entities/contact_story_entity.dart';

class UserContactsStoryEntity {
  final List<ContactStoryEntity> viewedContacts;
  final List<ContactStoryEntity> unViewedContacts;

  UserContactsStoryEntity({
    required this.viewedContacts,
    required this.unViewedContacts,
  });

  factory UserContactsStoryEntity.empty() {
    return UserContactsStoryEntity(
      unViewedContacts: [],
      viewedContacts: [],
    );
  }

  UserContactsStoryEntity copyWith({
    List<ContactStoryEntity>? viewedContacts,
    List<ContactStoryEntity>? unViewedContacts,
  }) {
    return UserContactsStoryEntity(
      viewedContacts: viewedContacts ?? this.viewedContacts,
      unViewedContacts: unViewedContacts ?? this.unViewedContacts,
    );
  }

  List<ContactStoryEntity> getCurrentStoriesList(
      {required ContactStoryEntity selectedContactStory}) {
        unViewedContacts.forEach((element) => log(element.contactId.toString()),);
        log("message");
        log('selected ${selectedContactStory.contactId}');
    if (viewedContacts.contains(selectedContactStory)) {
      return viewedContacts;
    } else if (unViewedContacts.contains(selectedContactStory)) {
      return unViewedContacts;
    } else {
      log("can not get the story in viewed and unviewed");
      return [];
    }
  }
}