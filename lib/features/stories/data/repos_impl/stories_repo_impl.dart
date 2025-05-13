import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:whatsapp/core/api/api_consumer.dart';
import 'package:whatsapp/core/api/api_keys.dart';
import 'package:whatsapp/core/api/end_points.dart';
import 'package:whatsapp/core/errors/exceptions.dart';
import 'package:whatsapp/core/errors/failures.dart';
import 'package:whatsapp/features/stories/data/models/story_model.dart';
import 'package:whatsapp/features/stories/data/models/user_contact_story_model.dart';
import 'package:whatsapp/features/stories/domain/entities/story_entity.dart';
import 'package:whatsapp/features/stories/domain/entities/user_contacts_story_entity.dart';
import 'package:whatsapp/features/stories/domain/repos/stories_repo.dart';

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
  Future<Either<Failure, List<StoryEntity>>> getCurrentUserStory() async {
    try {
      final result = await apiConsumer.get(
        EndPoints.getCurrentUserStory,
      );

      List<StoryEntity> stories = [];
      final List data = result[ApiKeys.data];

      data.map(
        (story) => stories.add(
          StoryModel.fromJson(story).toEntity(),
        ),
      );

      return Right(stories);
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
        EndPoints.getCurrentUserStory,
      );

      UserContactsStoryEntity userContactsStoryEntity = UserContactsStoryModel.fromJson(result);

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
}
