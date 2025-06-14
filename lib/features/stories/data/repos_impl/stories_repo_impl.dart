import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:whatsapp/core/api/api_consumer.dart';
import 'package:whatsapp/core/api/api_keys.dart';
import 'package:whatsapp/core/api/end_points.dart';
import 'package:whatsapp/core/errors/exceptions.dart';
import 'package:whatsapp/core/errors/failures.dart';
import 'package:whatsapp/core/helpers/get_current_user_entity.dart';
import 'package:whatsapp/features/stories/data/models/contact_story_model.dart';
import 'package:whatsapp/features/stories/data/models/story_model.dart';
import 'package:whatsapp/features/stories/data/models/user_contact_story_model.dart';
import 'package:whatsapp/features/stories/domain/entities/contact_story_entity.dart';
import 'package:whatsapp/features/stories/domain/entities/story_entity.dart';
import 'package:whatsapp/features/stories/domain/entities/user_contacts_story_entity.dart';
import 'package:whatsapp/features/stories/domain/repos/stories_repo.dart';
import 'package:whatsapp/features/user/domain/user_entity.dart';

class StoriesRepoImpl extends StoriesRepo {
  final ApiConsumer apiConsumer;

  StoriesRepoImpl({required this.apiConsumer});

  @override
  Future<Either<Failure, StoryEntity>> createNewStory(
      {required Map<String, dynamic> data}) async {
    try {
      final result = await apiConsumer.post(
        EndPoints.createStory,
        data: data,
        isFromData: true,
      );

      StoryEntity storyEntity = StoryModel.fromJson(result[ApiKeys.newStory]);

      return Right(storyEntity);
    } on UnAuthorizedException {
      log("throw unAuthorizedException in story repo");
      return Left(UnAuthorizedException());
    } on ConnectionException catch (e) {
      return Left(CustomException(message: e.message));
    } on ServerException {
      return Left(CustomException(
          message: "Something went wrong. Please try again later."));
    }
  }

  @override
  Future<Either<Failure, ContactStoryEntity>> getCurrentUserStory() async {
    try {
      final result = await apiConsumer.get(
        EndPoints.getCurrentUserStory,
      );

      final UserEntity currentUser = getCurrentUserEntity();

      final Map<String, dynamic> json = {
        'id': currentUser.id,
        'name': currentUser.name,
        'profile_image': currentUser.profileImage,
        'statuses': result['data'],
      };

      final ContactStoryEntity contactStoryEntity =
          ContactStoryModel.fromJson(json).toEntity();

      return Right(contactStoryEntity);
    } on UnAuthorizedException {
      log("throw unAuthorizedException in story repo");
      return Left(UnAuthorizedException());
    } on ConnectionException catch (e) {
      return Left(CustomException(message: e.message));
    } on ServerException {
      return Left(CustomException(
          message: "Something went wrong. Please try again later."));
    }
  }

  @override
  Future<Either<Failure, UserContactsStoryEntity>>
      getUserContactsStory() async {
    try {
      final result = await apiConsumer.get(
        EndPoints.getUserContactsStory,
      );

      if (result["viewedContacts"] != null) {
        for (var contact in result["viewedContacts"]) {
          for (var status in contact["statuses"]) {
            status.remove("views");
            status.remove("reacts");
          }
        }
      }

      if (result["unviewedContacts"] != null) {
        for (var contact in result["unviewedContacts"]) {
          for (var status in contact["statuses"]) {
            status.remove("views");
            status.remove("reacts");
          }
        }
      }

      UserContactsStoryEntity userContactsStoryEntity =
          UserContactsStoryModel.fromJson(result).toEntity();

      return Right(userContactsStoryEntity);
    } on UnAuthorizedException {
      log("throw unAuthorizedException in story repo");
      return Left(UnAuthorizedException());
    } on ConnectionException catch (e) {
      return Left(CustomException(message: e.message));
    } on ServerException {
      return Left(CustomException(
          message: "Something went wrong. Please try again later."));
    }
  }

  @override
  Future<Either<Failure, void>> viewStory({required int storyId}) async {
    try {
      await apiConsumer.post(
        EndPoints.viewStory(storyId: storyId),
      );

      return Right(null);
    } on UnAuthorizedException {
      log("throw unAuthorizedException in story repo");
      return Left(UnAuthorizedException());
    } on ConnectionException catch (e) {
      return Left(CustomException(message: e.message));
    } on ServerException {
      return Left(CustomException(
          message: "Something went wrong. Please try again later."));
    }
  }

  @override
  Future<Either<Failure, void>> reactStory({
    required int storyId,
  }) async {
    try {
      await apiConsumer.post(
        EndPoints.reactStory(storyId: storyId),
      );

      return Right(null);
    } on UnAuthorizedException {
      log("throw unAuthorizedException in story repo");
      return Left(UnAuthorizedException());
    } on ConnectionException catch (e) {
      return Left(CustomException(message: e.message));
    } on ServerException {
      return Left(CustomException(
          message: "Something went wrong. Please try again later."));
    }
  }

  @override
  Future<Either<Failure, void>> deleteStory({
    required int storyId,
  }) async {
    try {
      await apiConsumer.post(
        EndPoints.deleteStory(storyId: storyId),
      );

      return Right(null);
    } on UnAuthorizedException {
      log("throw unAuthorizedException in story repo");
      return Left(UnAuthorizedException());
    } on ConnectionException catch (e) {
      return Left(CustomException(message: e.message));
    } on ServerException {
      return Left(CustomException(
          message: "Something went wrong. Please try again later."));
    }
  }
}
