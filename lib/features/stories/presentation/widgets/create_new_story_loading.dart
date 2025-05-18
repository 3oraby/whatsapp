import 'package:flutter/material.dart';
import 'package:whatsapp/core/widgets/horizontal_gap.dart';

class CreateNewStoryLoading extends StatelessWidget {
  const CreateNewStoryLoading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.access_time_outlined),
        const HorizontalGap(8),
        Text("Sending 1")
      ],
    );
  }
}
