import 'package:whatsapp/features/user/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    super.phoneNumber,
    super.description,
    super.profileImage,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['userId'] ?? json['id'],
      name: json['name'],
      phoneNumber: json['phone_number'],
      description: json['discription'],
      email: json['email'] ?? "",
      profileImage: json['profile_image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone_number': phoneNumber,
      'discription': description,
      'email': email,
      'profile_image': profileImage,
    };
  }

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      name: entity.name,
      phoneNumber: entity.phoneNumber,
      description: entity.description,
      email: entity.email,
      profileImage: entity.profileImage,
    );
  }

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      name: name,
      phoneNumber: phoneNumber,
      description: description,
      email: email,
      profileImage: profileImage,
    );
  }

  UserModel copyWith({
    int? id,
    String? name,
    String? phoneNumber,
    String? description,
    String? email,
    String? profileImage,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      description: description ?? this.description,
      email: email ?? this.email,
      profileImage: profileImage ?? this.profileImage,
    );
  }
}
