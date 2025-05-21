import 'package:flutter/material.dart';

class LeadingArrowBack extends StatelessWidget {
  const LeadingArrowBack({
    super.key,
    this.color,
  });
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      icon: Icon(
        Icons.arrow_back_ios,
        color: color,
      ),
    );
  }
}
