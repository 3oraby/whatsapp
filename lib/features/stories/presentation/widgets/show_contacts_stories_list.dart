import 'package:flutter/material.dart';
import 'package:whatsapp/core/utils/app_text_styles.dart';
import 'package:whatsapp/core/widgets/vertical_gap.dart';
import 'package:whatsapp/features/stories/domain/entities/contact_story_entity.dart';
import 'package:whatsapp/features/stories/presentation/widgets/custom_user_story_item.dart';

class ShowContactsStoriesList extends StatelessWidget {
  const ShowContactsStoriesList({
    super.key,
    required this.description,
    required this.stories,
  });

  final String description;
  final List<ContactStoryEntity> stories;
  @override
  Widget build(BuildContext context) {
    if (stories.isEmpty) {
      return SizedBox();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          description,
          style: AppTextStyles.poppinsMedium(context, 18).copyWith(
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        const VerticalGap(24),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.all(0),
          separatorBuilder: (context, index) => const VerticalGap(12),
          itemCount: stories.length,
          itemBuilder: (context, index) => CustomUserStoryItem(
            contactStoryEntity: stories[index],
            showBottomDivider: index != stories.length - 1,
          ),
        ),
      ],
    );
  }
}
