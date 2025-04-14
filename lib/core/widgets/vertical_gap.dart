import 'package:flutter/material.dart';

class VerticalGap extends StatelessWidget {
  const VerticalGap(this.height, {super.key});

  final double height;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
    );
  }
}
