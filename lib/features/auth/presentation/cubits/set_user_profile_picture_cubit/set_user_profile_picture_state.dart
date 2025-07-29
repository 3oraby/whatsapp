part of 'set_user_profile_picture_cubit.dart';

abstract class SetUserProfilePictureState {}

final class SetUserProfilePictureInitial extends SetUserProfilePictureState {}

final class SetUserProfilePictureLoadingState
    extends SetUserProfilePictureState {}

final class SetUserProfilePictureLoadedState
    extends SetUserProfilePictureState {
  final String imageUrl;
  SetUserProfilePictureLoadedState({
    required this.imageUrl,
  });
}

final class SetUserProfilePictureFailureState
    extends SetUserProfilePictureState {
  final String message;
  SetUserProfilePictureFailureState({
    required this.message,
  });
}
