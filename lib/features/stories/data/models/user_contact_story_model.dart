import 'package:whatsapp/features/stories/data/models/contact_story_model.dart';
import 'package:whatsapp/features/stories/domain/entities/contact_story_entity.dart';
import 'package:whatsapp/features/stories/domain/entities/user_contacts_story_entity.dart';

class UserContactsStoryModel extends UserContactsStoryEntity {
  UserContactsStoryModel({
    required super.viewedContacts,
    required super.unViewedContacts,
  });

  factory UserContactsStoryModel.fromJson(Map<String, dynamic> json) =>
      UserContactsStoryModel(
        viewedContacts: (json['viewedContacts'] as List)
            .map((e) => ContactStoryModel.fromJson(e))
            .toList(),
        unViewedContacts: (json['unviewedContacts'] as List)
            .map((e) => ContactStoryModel.fromJson(e))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'viewedContacts': viewedContacts
            .map((e) => (e as ContactStoryModel).toJson())
            .toList(),
        'unviewedContacts': unViewedContacts
            .map((e) => (e as ContactStoryModel).toJson())
            .toList(),
      };

  factory UserContactsStoryModel.fromEntity(UserContactsStoryEntity entity) =>
      UserContactsStoryModel(
        viewedContacts: entity.viewedContacts,
        unViewedContacts: entity.unViewedContacts,
      );

  UserContactsStoryEntity toEntity() => UserContactsStoryEntity(
        viewedContacts: viewedContacts,
        unViewedContacts: unViewedContacts,
      );

  UserContactsStoryModel copyWith({
    List<ContactStoryEntity>? viewedContacts,
    List<ContactStoryEntity>? unViewedContacts,
  }) =>
      UserContactsStoryModel(
        viewedContacts: viewedContacts ?? this.viewedContacts,
        unViewedContacts: unViewedContacts ?? this.unViewedContacts,
      );
}
