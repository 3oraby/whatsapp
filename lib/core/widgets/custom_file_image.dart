import 'dart:io';
import 'package:flutter/material.dart';

class CustomFileImage extends StatelessWidget {
  final File file;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Widget? placeholder;
  final Widget? errorWidget;
  final double? borderRadius;

  const CustomFileImage({
    super.key,
    required this.file,
    this.width,
    this.height,
    this.fit,
    this.placeholder,
    this.errorWidget,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final image = Image.file(
      file,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) =>
          errorWidget ??
          SizedBox(
            width: width,
            height: height,
            child: Container(
              color: Colors.grey[300],
              child: const Icon(Icons.error, color: Colors.red),
            ),
          ),
    );

    return borderRadius != null
        ? ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius!),
            child: image,
          )
        : image;
  }
}
