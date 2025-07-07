import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:whatsapp/core/constants/storage_keys.dart';
import 'package:whatsapp/core/storage/app_storage_helper.dart';

Future<String?> getLocalAccessToken() async {
  final accessToken =
      await AppStorageHelper.getSecureData(StorageKeys.accessToken.toString());

  if (accessToken == null) {
    debugPrint("⛔ No access token found, socket not connected.");
  }
  log("get locally accessToken: $accessToken");

  return accessToken;
}
