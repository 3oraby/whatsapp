import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/core/helpers/show_custom_snack_bar.dart';
import 'package:whatsapp/features/stories/domain/entities/contact_story_entity.dart';
import 'package:whatsapp/features/stories/presentation/cubits/create_new_story/create_new_story_cubit.dart';
import 'package:whatsapp/features/stories/presentation/widgets/my_story_add_prompt_item.dart';
import 'package:whatsapp/features/stories/presentation/widgets/my_story_with_status_item.dart';

class MyStoryItem extends StatefulWidget {
  const MyStoryItem({
    super.key,
    required this.contactStoryEntity,
  });

  final ContactStoryEntity contactStoryEntity;

  @override
  State<MyStoryItem> createState() => _MyStoryItemState();
}

class _MyStoryItemState extends State<MyStoryItem> {
  late ContactStoryEntity currentUserStories;

  @override
  void initState() {
    super.initState();
    currentUserStories = widget.contactStoryEntity;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateNewStoryCubit, CreateNewStoryState>(
      listener: (context, state) {
        if (state is CreateNewStoryLoadedState) {
          setState(() {
            currentUserStories.stories.add(state.storyEntity);
          });
        }else if (state is CreateNewStoryFailureState){
          showCustomSnackBar(context, state.message);
        }
      },
      child: widget.contactStoryEntity.stories.isEmpty
          ? MyStoryAddPromptItem(
              currentUserProfileImage: widget.contactStoryEntity.profileImage,
            )
          : MyStoryWithStatusItem(
              contactStoryEntity: widget.contactStoryEntity),
    );
  }
}
