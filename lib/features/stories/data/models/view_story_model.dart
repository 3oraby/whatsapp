import 'package:whatsapp/features/stories/domain/entities/view_story_entity.dart';
import 'package:whatsapp/features/user/data/models/user_model.dart';

class ViewStoryModel extends ViewStoryEntity {
  ViewStoryModel({
    required super.id,
    required super.createdAt,
    required super.user,
  });

  factory ViewStoryModel.fromJson(Map<String, dynamic> json) => ViewStoryModel(
        id: json['id'],
        createdAt: DateTime.parse(json['createdAt']),
        user: UserModel.fromJson(json['user']).toEntity(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'createdAt': createdAt.toIso8601String(),
        'user': UserModel.fromEntity(user).toJson(),
      };

  factory ViewStoryModel.fromEntity(ViewStoryEntity entity) => ViewStoryModel(
        id: entity.id,
        createdAt: entity.createdAt,
        user: entity.user,
      );

  ViewStoryEntity toEntity() => ViewStoryEntity(
        id: id,
        createdAt: createdAt,
        user: user,
      );
}
