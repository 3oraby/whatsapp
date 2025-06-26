
import 'package:whatsapp/features/user/domain/entities/user_entity.dart';

class ReactStoryEntity {
  final int id;
  final DateTime createdAt;
  final UserEntity user;

  ReactStoryEntity({
    required this.id,
    required this.createdAt,
    required this.user,
  });
}
