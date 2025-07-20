import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:whatsapp/core/widgets/gallery_image_picker.dart';

class CreateStoryGalleryPickerTab extends StatelessWidget {
  final void Function(AssetEntity) onImageSelected;

  const CreateStoryGalleryPickerTab({
    super.key,
    required this.onImageSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GalleryImagePicker(
      onImageSelected: onImageSelected,
      crossAxisCount: 2,
    );
  }
}
