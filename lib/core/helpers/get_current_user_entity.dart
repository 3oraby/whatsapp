import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:whatsapp/core/constants/storage_keys.dart';
import 'package:whatsapp/core/errors/failures.dart';
import 'package:whatsapp/core/storage/app_storage_helper.dart';
import 'package:whatsapp/features/user/data/models/user_model.dart';
import 'package:whatsapp/features/user/domain/entities/user_entity.dart';

UserEntity? getCurrentUserEntity() {
  try {
    var jsonString =
        AppStorageHelper.getString(StorageKeys.currentUser.toString());

    if (jsonString == null || jsonString.isEmpty) {
      debugPrint(
          "User data is null or empty. error in getCurrentUserEntityMethod");
      return null;
    }

    debugPrint("current user data $jsonString");
    var jsonData = jsonDecode(jsonString);

    UserEntity userEntity = UserModel.fromJson(jsonData);

    return userEntity;
  } catch (e) {
    debugPrint("Error while fetching the current user entity: $e");
    throw const CustomException(
        message: 'An error occurred. Please try again.');
  }
}
