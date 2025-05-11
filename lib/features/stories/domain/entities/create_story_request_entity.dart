import 'dart:io';

class CreateStoryRequestEntity {
  final String content;
  final File? imageFile;

  CreateStoryRequestEntity({
    required this.content,
    this.imageFile,
  });
}
