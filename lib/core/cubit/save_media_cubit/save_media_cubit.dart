import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';

part 'save_media_state.dart';

class SaveMediaCubit extends Cubit<SaveMediaState> {
  SaveMediaCubit() : super(SaveMediaInitial());

  Future<void> saveMedia(String mediaUrl) async {
    try {
      final isVideo = mediaUrl.toLowerCase().endsWith(".mp4");
      bool? success;

      if (isVideo) {
        success = await GallerySaver.saveVideo(mediaUrl);
      } else {
        success = await GallerySaver.saveImage(mediaUrl);
      }

      if (success == true) {
        emit(SaveMediaSuccess());
      } else {
        emit(SaveMediaFailure("Failed to save"));
      }
    } catch (e) {
      log("failed to save the media: ${e.toString()}");
      emit(SaveMediaFailure("Failed to save"));
    }
  }
}
