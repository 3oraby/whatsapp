import 'package:whatsapp/features/user/domain/entities/user_current_status_entity.dart';

class UserCurrentStatusModel extends UserCurrentStatusEntity {
  const UserCurrentStatusModel({
    required super.userId,
    required super.lastSeen,
    required super.isOnline,
    required super.createdAt,
    required super.updatedAt,
  });

  factory UserCurrentStatusModel.fromJson(Map<String, dynamic> json) {
    return UserCurrentStatusModel(
      userId: json['user_id'],
      lastSeen: DateTime.parse(json['last_seen']),
      isOnline: json['isOnline'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'last_seen': lastSeen.toIso8601String(),
      'isOnline': isOnline,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory UserCurrentStatusModel.fromEntity(UserCurrentStatusEntity entity) {
    return UserCurrentStatusModel(
      userId: entity.userId,
      lastSeen: entity.lastSeen,
      isOnline: entity.isOnline,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  UserCurrentStatusEntity toEntity() {
    return UserCurrentStatusEntity(
      userId: userId,
      lastSeen: lastSeen,
      isOnline: isOnline,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
