import 'package:whatsapp/features/stories/data/models/story_model.dart';
import 'package:whatsapp/features/stories/domain/entities/contact_story_entity.dart';
class ContactStoryModel extends ContactStoryEntity {
  ContactStoryModel({
    required super.contactId,
    required super.name,
    required super.profileImage,
    required super.stories,
  });

  factory ContactStoryModel.fromJson(Map<String, dynamic> json) =>
      ContactStoryModel(
        contactId: json['id'],
        name: json['name'],
        profileImage: json['profile_image'],
        stories: (json['statuses'] as List)
            .map((e) => StoryModel.fromJson(e))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'id': contactId,
        'name': name,
        'profile_image': profileImage,
        'statuses': stories.map((e) => (e as StoryModel).toJson()).toList(),
      };

  factory ContactStoryModel.fromEntity(ContactStoryEntity entity) =>
      ContactStoryModel(
        contactId: entity.contactId,
        name: entity.name,
        profileImage: entity.profileImage,
        stories: entity.stories,
      );

  ContactStoryEntity toEntity() => ContactStoryEntity(
        contactId: contactId,
        name: name,
        profileImage: profileImage,
        stories: stories,
      );
}
