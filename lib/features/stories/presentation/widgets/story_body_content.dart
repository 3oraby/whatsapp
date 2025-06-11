import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';
import 'package:whatsapp/features/stories/presentation/widgets/story_content_overlay.dart';

class StoryBodyContent extends StatelessWidget {
  final String? mediaUrl;
  final String? content;

  const StoryBodyContent({
    super.key,
    required this.mediaUrl,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage = mediaUrl != null;
    final hasText = content != null;

    if (hasImage) {
      return Expanded(
        child: CachedNetworkImage(
          width: double.infinity,
          fit: BoxFit.cover,
          imageUrl: mediaUrl!,
        ),
      );
    }

    if (hasText) {
      return hasImage
          ? StoryContentOverlay(
              text: content!,
              alignAtBottom: true,
            )
          : Expanded(
              child: StoryContentOverlay(
                text: content!,
                alignAtBottom: false,
              ),
            );
    }

    return const SizedBox.shrink();
  }
}
