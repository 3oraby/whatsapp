import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/core/helpers/show_custom_snack_bar.dart';
import 'package:whatsapp/core/utils/app_colors.dart';
import 'package:whatsapp/core/widgets/custom_background_icon.dart';
import 'package:whatsapp/features/stories/domain/entities/story_entity.dart';
import 'package:whatsapp/features/stories/presentation/cubits/react_story/react_story_cubit.dart';

class CustomReactStoryButton extends StatelessWidget {
  const CustomReactStoryButton({
    super.key,
    required this.story,
    required this.currentStoryIndex,
  });

  final StoryEntity story;
  final int currentStoryIndex;

  @override
  Widget build(BuildContext context) {
    return ReactStoryButtonBlocConsumerBody(
      story: story,
      currentStoryIndex: currentStoryIndex,
    );
  }
}

class ReactStoryButtonBlocConsumerBody extends StatefulWidget {
  const ReactStoryButtonBlocConsumerBody({
    super.key,
    required this.story,
    required this.currentStoryIndex,
  });
  final StoryEntity story;
  final int currentStoryIndex;

  @override
  State<ReactStoryButtonBlocConsumerBody> createState() =>
      _ReactStoryButtonBlocConsumerBodyState();
}

class _ReactStoryButtonBlocConsumerBodyState
    extends State<ReactStoryButtonBlocConsumerBody> {
  late bool isActive;

  @override
  void initState() {
    super.initState();
    isActive = widget.story.isReacted ?? false;
  }

  _onToggleLikeButtonPressed() async {
    BlocProvider.of<ReactStoryCubit>(context).reactStory(
      story: widget.story,
      currentStoryIndex: widget.currentStoryIndex,
    );

    setState(() {
      isActive = !isActive;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ReactStoryCubit, ReactStoryState>(
      listener: (context, state) {
        if (state is ReactStoryFailureState) {
          showCustomSnackBar(context, context.tr(state.message));
          setState(() {
            isActive = !isActive;
          });
        }
      },
      builder: (context, state) {
        return CustomBackgroundIcon(
          onTap: _onToggleLikeButtonPressed,
          backgroundColor: Colors.black54,
          iconColor: isActive ? AppColors.actionColor : Colors.white,
          iconData: isActive ? Icons.favorite : Icons.favorite_border,
        );
      },
    );
  }
}
