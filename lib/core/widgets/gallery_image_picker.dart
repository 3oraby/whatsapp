import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';

class GalleryImagePicker extends StatefulWidget {
  final void Function(AssetEntity image) onImageSelected;
  final int crossAxisCount;

  const GalleryImagePicker({
    super.key,
    required this.onImageSelected,
    this.crossAxisCount = 3,
  });

  @override
  State<GalleryImagePicker> createState() => _GalleryImagePickerState();
}

class _GalleryImagePickerState extends State<GalleryImagePicker> {
  List<AssetEntity> _images = [];

  @override
  void initState() {
    super.initState();
    _handlePermissionAndLoadImages();
  }

  Future<void> _handlePermissionAndLoadImages() async {
    final permissionStatus = await _requestPhotosPermission();
    if (!permissionStatus) {
      debugPrint('Permission denied by user.');
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
    debugPrint('📷 Loading albums...');
    final albums = await PhotoManager.getAssetPathList(
      type: RequestType.image,
      onlyAll: true,
    );

    debugPrint('📁 Albums count: ${albums.length}');

    if (albums.isEmpty) return;

    final recentAlbum = albums.first;
    final images = await recentAlbum.getAssetListPaged(page: 0, size: 100);

    debugPrint('🖼️ Loaded ${images.length} images');

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
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: widget.crossAxisCount,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
            ),
            itemBuilder: (context, index) {
              return FutureBuilder<Uint8List?>(
                future: _images[index].thumbnailDataWithSize(
                  const ThumbnailSize(200, 200),
                ),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return GestureDetector(
                    onTap: () => widget.onImageSelected(_images[index]),
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
