import 'package:flutter/material.dart';
import 'package:whatsapp/core/widgets/custom_background_icon.dart';
import 'package:whatsapp/core/widgets/custom_scrollable_text_field.dart';
import 'package:whatsapp/core/widgets/horizontal_gap.dart';

class StoryInteractionPart extends StatelessWidget {
  const StoryInteractionPart({
    super.key,
    required this.textFieldScrollController,
    required this.textController,
  });

  final ScrollController textFieldScrollController;
  final TextEditingController textController;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomScrollableTextField(
            textFieldScrollController: textFieldScrollController,
            textController: textController,
            borderWidth: 0,
            hintText: "Reply..",
          ),
        ),
        const HorizontalGap(16),
        CustomBackgroundIcon(
          backgroundColor: Colors.black54,
          iconColor: Colors.white,
          iconData: Icons.favorite_border,
        )
      ],
    );
  }
}
