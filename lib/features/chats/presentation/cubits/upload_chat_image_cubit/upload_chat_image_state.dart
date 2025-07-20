part of 'upload_chat_image_cubit.dart';

abstract class UploadChatImageState {}

class UploadChatImageInitial extends UploadChatImageState {}

class UploadChatImageLoadingState extends UploadChatImageState {}

class UploadChatImageLoadedState extends UploadChatImageState {
  final String mediaUrl;

  UploadChatImageLoadedState({required this.mediaUrl});
}

class UploadChatImageFailureState extends UploadChatImageState {
  final String message;

  UploadChatImageFailureState({required this.message});
}
