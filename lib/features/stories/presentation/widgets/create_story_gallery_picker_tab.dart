import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:permission_handler/permission_handler.dart';

class CreateStoryGalleryPickerTab extends StatefulWidget {
  final void Function(AssetEntity) onImageSelected;
  const CreateStoryGalleryPickerTab({
    super.key,
    required this.onImageSelected,
  });

  @override
  State<CreateStoryGalleryPickerTab> createState() =>
      _CreateStoryGalleryPickerTabState();
}

class _CreateStoryGalleryPickerTabState
    extends State<CreateStoryGalleryPickerTab> {
  List<AssetEntity> _images = [];

  @override
  void initState() {
    super.initState();
    _handlePermissionAndLoadImages();
  }

  Future<void> _handlePermissionAndLoadImages() async {
    final permissionStatus = await _requestPhotosPermission();

    if (!permissionStatus) {
      log('Permission denied by user.');
      return;
    }

    await _loadImages();
  }

  Future<bool> _requestPhotosPermission() async {
    await PhotoManager.getAssetPathList(
      type: RequestType.image,
    );

    if (await Permission.photos.request().isGranted) {
      return true;
    }

    if (await Permission.storage.request().isGranted) {
      return true;
    }

    return false;
  }

  Future<void> _loadImages() async {
    final albums = await PhotoManager.getAssetPathList(
      type: RequestType.image,
      onlyAll: true,
    );

    if (albums.isEmpty) return;

    final recentAlbum = albums.first;
    final images = await recentAlbum.getAssetListPaged(page: 0, size: 100);

    setState(() {
      _images = images;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _images.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : GridView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: _images.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
            ),
            itemBuilder: (context, index) {
              return FutureBuilder(
                future: _images[index].thumbnailDataWithSize(
                  const ThumbnailSize(200, 200),
                ),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: Text("no images"),
                    );
                  }

                  return GestureDetector(
                    onTap: () async {
                      widget.onImageSelected(_images[index]);
                    },
                    child: Image.memory(
                      snapshot.data!,
                      fit: BoxFit.cover,
                    ),
                  );
                },
              );
            },
          );
  }
}
