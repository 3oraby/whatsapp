import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/core/utils/app_text_styles.dart';
import 'package:whatsapp/core/widgets/vertical_gap.dart';
import 'package:whatsapp/features/stories/domain/entities/contact_story_entity.dart';
import 'package:whatsapp/features/stories/presentation/cubits/get_current_stories/get_current_stories_cubit.dart';
import 'package:whatsapp/features/stories/presentation/widgets/my_story_item.dart';
import 'package:whatsapp/features/stories/presentation/widgets/show_contacts_stories_list.dart';

class ShowCurrentStoriesBody extends StatelessWidget {
  const ShowCurrentStoriesBody({
    super.key,
    required this.currentUserContactStoryEntity,
    required this.viewedContactsStories,
    required this.unViewedContactsStories,
  });

  final ContactStoryEntity currentUserContactStoryEntity;
  final List<ContactStoryEntity> viewedContactsStories;
  final List<ContactStoryEntity> unViewedContactsStories;
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async{
        BlocProvider.of<GetCurrentStoriesCubit>(context).getCurrentStories();
      },
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Updates",
              style: AppTextStyles.poppinsBold(context, 48),
            ),
            const VerticalGap(24),
            MyStoryItem(
              contactStoryEntity: currentUserContactStoryEntity,
            ),
            const VerticalGap(32),
            ShowContactsStoriesList(
              description: "Recent updates",
              stories: unViewedContactsStories,
            ),
            if (unViewedContactsStories.isNotEmpty) const VerticalGap(24),
            ShowContactsStoriesList(
              description: "Viewed updates",
              stories: viewedContactsStories,
            ),
            if (viewedContactsStories.isNotEmpty) const VerticalGap(24),
          ],
        ),
      ),
    );
  }
}
