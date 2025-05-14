import 'package:flutter/material.dart';
import 'package:whatsapp/features/stories/domain/entities/contact_story_entity.dart';
import 'package:whatsapp/features/stories/presentation/widgets/my_story_add_prompt_item.dart';
import 'package:whatsapp/features/stories/presentation/widgets/my_story_with_status_item.dart';

class MyStoryItem extends StatelessWidget {
  const MyStoryItem({
    super.key,
    required this.contactStoryEntity,
  });

  final ContactStoryEntity contactStoryEntity;
  @override
  Widget build(BuildContext context) {
    return contactStoryEntity.stories.isEmpty
        ? MyStoryAddPromptItem(
            currentUserProfileImage: contactStoryEntity.profileImage,
          )
        : MyStoryWithStatusItem(contactStoryEntity: contactStoryEntity);
  }
}

