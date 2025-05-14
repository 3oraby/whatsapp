enum StorageKeys {
  accessToken,
  refreshToken,
  isDarkMode,
  isArabic,
  userEmail,
  isLoggedIn,
  currentUser,
}

extension StorageKeysExt on StorageKeys {
  String get key => toString().split('.').last;
}
