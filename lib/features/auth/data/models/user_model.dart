import 'package:whatsapp/features/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.userId,
    required super.firstName,
    required super.lastName,
    required super.email,
    required super.phoneNumber,
    super.profilePicUrl,
    required super.joinedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'profilePicUrl': profilePicUrl,
      'phoneNumber': phoneNumber,
      'joinedAt': joinedAt
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      profilePicUrl: json['profilePicUrl'],
      phoneNumber: json['phoneNumber'],
      joinedAt: json['joinedAt'],
    );
  }

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      userId: entity.userId,
      firstName: entity.firstName,
      lastName: entity.lastName,
      email: entity.email,
      profilePicUrl: entity.profilePicUrl,
      phoneNumber: entity.phoneNumber,
      joinedAt: entity.joinedAt,
    );
  }

  UserEntity toEntity() {
    return UserEntity(
      userId: userId,
      firstName: firstName,
      lastName: lastName,
      email: email,
      profilePicUrl: profilePicUrl,
      phoneNumber: phoneNumber,
      joinedAt: joinedAt,
    );
  }
}
