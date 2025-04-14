import 'package:flutter/material.dart';

class HorizontalGap extends StatelessWidget {
  const HorizontalGap(this.width, {super.key});

  final double width;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
    );
  }
}
