class UserCurrentStatusEntity {
  final int userId;
  final DateTime lastSeen;
  final bool isOnline;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserCurrentStatusEntity({
    required this.userId,
    required this.lastSeen,
    required this.isOnline,
    required this.createdAt,
    required this.updatedAt,
  });

  UserCurrentStatusEntity copyWith({
    int? userId,
    DateTime? lastSeen,
    bool? isOnline,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserCurrentStatusEntity(
      userId: userId ?? this.userId,
      lastSeen: lastSeen ?? this.lastSeen,
      isOnline: isOnline ?? this.isOnline,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
