import 'package:dartz/dartz.dart';
import 'package:whatsapp/core/errors/failures.dart';
import 'package:whatsapp/features/stories/domain/entities/contact_story_entity.dart';
import 'package:whatsapp/features/stories/domain/entities/story_entity.dart';
import 'package:whatsapp/features/stories/domain/entities/user_contacts_story_entity.dart';

abstract class StoriesRepo {
  Future<Either<Failure, StoryEntity>> createNewStory({
    required Map<String, dynamic> data,
  });

  Future<Either<Failure, UserContactsStoryEntity>> getUserContactsStory();

  Future<Either<Failure, ContactStoryEntity>> getCurrentUserStory();

  Future<Either<Failure, void>> viewStory({required int storyId});

  Future<Either<Failure, void>> reactStory({required int storyId});
  Future<Either<Failure, void>> deleteStory({required int storyId});
}
