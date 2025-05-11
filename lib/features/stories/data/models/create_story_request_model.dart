import 'package:whatsapp/features/stories/domain/entities/create_story_request_entity.dart';

class CreateStoryRequestModel extends CreateStoryRequestEntity {
  CreateStoryRequestModel({
    required super.content,
    super.imageFile,
  });

  Map<String, dynamic> toJson() => {
        "content": content,
        "image": imageFile,
      };

  factory CreateStoryRequestModel.fromEntity(CreateStoryRequestEntity entity) =>
      CreateStoryRequestModel(
        content: entity.content,
        imageFile: entity.imageFile,
      );
}
