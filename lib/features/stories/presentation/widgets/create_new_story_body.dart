import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/core/services/image_picker_service.dart';
import 'package:whatsapp/features/stories/data/models/create_story_request_model.dart';
import 'package:whatsapp/features/stories/presentation/cubits/create_new_story/create_new_story_cubit.dart';

class CreateStoryBody extends StatefulWidget {
  const CreateStoryBody({super.key});

  @override
  State<CreateStoryBody> createState() => _CreateStoryBodyState();
}

class _CreateStoryBodyState extends State<CreateStoryBody> {
  final TextEditingController _contentController = TextEditingController();
  final ImagePickerService _imagePickerService = ImagePickerService();
  File? _pickedImage;

  Future<void> _pickImage() async {
    final image = await _imagePickerService.pickImageFromGallery();
    if (image != null) {
      setState(() {
        _pickedImage = image;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Story")),
      body: BlocConsumer<CreateNewStoryCubit, CreateNewStoryState>(
        listener: (context, state) {
          if (state is CreateNewStoryLoadedState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Story created successfully")),
            );
            _contentController.clear();
            setState(() => _pickedImage = null);
          } else if (state is CreateNewStoryFailureState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<CreateNewStoryCubit>();

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _contentController,
                  decoration: const InputDecoration(
                    labelText: "What's on your mind?",
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                _pickedImage != null
                    ? Image.file(
                        _pickedImage!,
                        height: 200,
                      )
                    : const SizedBox(
                        height: 200,
                        child: Placeholder(),
                      ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.image),
                  label: const Text("Pick Image"),
                ),
                const Spacer(),
                state is CreateNewStoryLoadingState
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () {
                          cubit.createNewStory(
                            data: CreateStoryRequestModel(
                              content: _contentController.text,
                              imageFile: _pickedImage,
                            ).toJson(),
                          );
                        },
                        child: const Text("Post Story"),
                      ),
              ],
            ),
          );
        },
      ),
    );
  }
}
