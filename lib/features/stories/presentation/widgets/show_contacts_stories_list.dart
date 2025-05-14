
import 'package:flutter/material.dart';
import 'package:whatsapp/features/stories/domain/entities/contact_story_entity.dart';
import 'package:whatsapp/features/stories/presentation/widgets/custom_user_story_item.dart';

class ShowContactsStoriesList extends StatelessWidget {
  const ShowContactsStoriesList({
    super.key,
    required this.stories,
  });

  final List<ContactStoryEntity> stories;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: stories.length,
      itemBuilder: (context, index) =>
          CustomUserStoryItem(contactStoryEntity: stories[index]),
    );
  }
}
