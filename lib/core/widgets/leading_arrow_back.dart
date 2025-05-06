import 'package:flutter/material.dart';

class LeadingArrowBack extends StatelessWidget {
  const LeadingArrowBack({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      icon: Icon(Icons.arrow_back_ios),
    );
  }
}
