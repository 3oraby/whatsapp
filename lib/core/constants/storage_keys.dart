enum StorageKeys {
  accessToken,
  refreshToken,
  isDarkMode,
  isArabic,
}

extension StorageKeysExt on StorageKeys {
  String get key => toString().split('.').last;
}
