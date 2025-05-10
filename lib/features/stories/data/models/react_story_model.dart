import 'package:whatsapp/features/stories/domain/entities/react_story_entity.dart';
import 'package:whatsapp/features/user/data/models/user_model.dart';

class ReactStoryModel extends ReactStoryEntity {
  ReactStoryModel({
    required super.id,
    required super.createdAt,
    required super.user,
  });

  factory ReactStoryModel.fromJson(Map<String, dynamic> json) =>
      ReactStoryModel(
        id: json['id'],
        createdAt: DateTime.parse(json['createdAt']),
        user: UserModel.fromJson(json['user']).toEntity(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'createdAt': createdAt.toIso8601String(),
        'user': UserModel.fromEntity(user).toJson(),
      };

  factory ReactStoryModel.fromEntity(ReactStoryEntity entity) =>
      ReactStoryModel(
        id: entity.id,
        createdAt: entity.createdAt,
        user: entity.user,
      );

  ReactStoryEntity toEntity() => ReactStoryEntity(
        id: id,
        createdAt: createdAt,
        user: user,
      );
}
