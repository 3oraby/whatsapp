import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CustomNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final ImageErrorWidgetBuilder? errorBuilder;
  final Widget? placeholder;
  final double? borderRadius;

  const CustomNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit,
    this.errorBuilder,
    this.placeholder,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final image = CachedNetworkImage(
      key: ValueKey(imageUrl),
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, url) {
        return SizedBox(
          width: width,
          height: height,
          child: Container(
            color: Colors.grey[300],
          ),
        );
      },
      errorWidget: (context, url, error) => SizedBox(
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
