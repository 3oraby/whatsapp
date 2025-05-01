import 'package:whatsapp/features/contacts/domain/entities/user_with_contact_status_entity.dart';
import 'package:whatsapp/features/user/data/models/user_model.dart';
import 'package:whatsapp/features/user/domain/user_entity.dart';

class UserWithContactStatusModel extends UserWithContactStatusEntity {
  UserWithContactStatusModel({
    required super.user,
    super.isContact,
  });

  factory UserWithContactStatusModel.fromJson(Map<String, dynamic> json) {
    return UserWithContactStatusModel(
      user: UserModel.fromJson(json['user']),
      isContact: json['is_contact'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': UserModel.fromEntity(user).toJson(),
      'is_contact': isContact,
    };
  }

  factory UserWithContactStatusModel.fromEntity(
      UserWithContactStatusEntity entity) {
    return UserWithContactStatusModel(
      user: entity.user,
      isContact: entity.isContact,
    );
  }

  UserWithContactStatusEntity toEntity() {
    return UserWithContactStatusEntity(
      user: user,
      isContact: isContact,
    );
  }

  UserWithContactStatusModel copyWith({
    UserEntity? user,
    bool? isContact,
  }) {
    return UserWithContactStatusModel(
      user: user ?? this.user,
      isContact: isContact ?? this.isContact,
    );
  }
}
