import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class FullUserProfileImgScreen extends StatelessWidget {
  const FullUserProfileImgScreen({
    super.key,
    required this.imagePath,
    required this.heroTag,
  });

  final String imagePath;
  final String heroTag;

  @override
  Widget build(BuildContext context) {
    final isFile = File(imagePath).existsSync();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(""),
      ),
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              onVerticalDragEnd: (details) {
                if (details.primaryVelocity != null &&
                    details.primaryVelocity! < -300) {
                  Navigator.pop(context);
                }
              },
              child: Center(
                child: Hero(
                  tag: heroTag,
                  child: isFile
                      ? Image.file(
                          File(imagePath),
                        )
                      : CachedNetworkImage(
                          imageUrl: imagePath,
                          height: MediaQuery.sizeOf(context).height * 0.5,
                          width: double.maxFinite,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
            ),
          ),
          Icon(
            Icons.keyboard_arrow_up,
            size: 72,
            color: Colors.grey,
          )
        ],
      ),
    );
  }
}
