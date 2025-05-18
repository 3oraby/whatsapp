import 'package:flutter/material.dart';

class CustomCancelIconButton extends StatelessWidget {
  const CustomCancelIconButton({
    super.key,
    this.onTap,
  });

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: const Icon(
        Icons.cancel_rounded,
        color: Colors.white,
        size: 34,
      ),
    );
  }
}
