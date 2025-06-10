import 'package:flutter/material.dart';
import 'package:whatsapp/core/utils/app_text_styles.dart';

class StoryContentOverlay extends StatefulWidget {
  final String text;
  final bool alignAtBottom;

  const StoryContentOverlay({
    super.key,
    required this.text,
    this.alignAtBottom = false,
  });

  @override
  State<StoryContentOverlay> createState() => StoryContentOverlayState();
}

class StoryContentOverlayState extends State<StoryContentOverlay> {
  bool isExpanded = false;
  bool isLongText = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _checkIfLongText();
  }

  void _checkIfLongText() {
    final textStyle = AppTextStyles.poppinsMedium(context, 16);
    final textSpan = TextSpan(text: widget.text, style: textStyle);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      maxLines: 1000,
    );
    textPainter.layout(
      maxWidth: MediaQuery.of(context).size.width - 32,
    );
    final numLines = textPainter.computeLineMetrics().length;

    if (numLines > 2) {
      setState(() {
        isLongText = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment:
          widget.alignAtBottom ? Alignment.bottomCenter : Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              child: Text(
                widget.text,
                style: AppTextStyles.poppinsMedium(context, 18)
                    .copyWith(color: Colors.white),
                maxLines: isExpanded ? null : 2,
                overflow:
                    isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
              ),
            ),
            if (isLongText && !isExpanded)
              TextButton(
                onPressed: () => setState(() => isExpanded = true),
                child: Text(
                  "More..",
                  style: AppTextStyles.poppinsMedium(context, 14)
                      .copyWith(color: Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
