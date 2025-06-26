import 'package:whatsapp/features/user/domain/entities/user_entity.dart';

class UserWithContactStatusEntity {
  final UserEntity user;
  bool? isContact;

  UserWithContactStatusEntity({
    required this.user,
    this.isContact,
  });
}
