import 'dart:convert';
import 'dart:developer';

import 'package:whatsapp/core/constants/storage_keys.dart';
import 'package:whatsapp/core/storage/app_storage_helper.dart';
import 'package:whatsapp/features/user/data/models/user_model.dart';
import 'package:whatsapp/features/user/domain/user_entity.dart';


Future<void> saveCurrentUserDataLocally({
  required UserEntity user,
}) async {
  try {
    log('save user data in prefs');
    var jsonData = jsonEncode(UserModel.fromEntity(user).toJson());
    log("new user data after save it: ${jsonData.toString()}");
    await AppStorageHelper.setString(
        StorageKeys.currentUser.toString(), jsonData);
  } on Exception catch (e) {
    log("exception in saveUserDataInPrefs ==> ${e.toString()}");
  }
}
