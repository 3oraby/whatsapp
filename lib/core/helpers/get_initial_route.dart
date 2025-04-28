import 'dart:developer';

import 'package:whatsapp/core/constants/storage_keys.dart';
import 'package:whatsapp/core/storage/app_storage_helper.dart';
import 'package:whatsapp/core/utils/app_routes.dart';

bool checkLoginState() {
  return AppStorageHelper.getBool(StorageKeys.isLoggedIn.toString()) ?? false;
}

String getInitialRoute() {
  bool isLoggedIn = checkLoginState();
  log(isLoggedIn ? "user is logged in" : "user is not logged in");
  if (isLoggedIn) {
    return Routes.homeRoute;
  } else {
    return Routes.signInRoute;
  }
}
