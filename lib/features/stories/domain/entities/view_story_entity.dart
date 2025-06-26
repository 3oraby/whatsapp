import 'package:whatsapp/features/user/domain/entities/user_entity.dart';

class ViewStoryEntity {
  final int id;
  final DateTime createdAt;
  final UserEntity user;

  ViewStoryEntity({
    required this.id,
    required this.createdAt,
    required this.user,
  });
}
