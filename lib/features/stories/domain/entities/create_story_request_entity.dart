import 'dart:io';

class CreateStoryRequestEntity {
  String? content;
  File? imageFile;

  CreateStoryRequestEntity({
    this.content,
    this.imageFile,
  });
}
