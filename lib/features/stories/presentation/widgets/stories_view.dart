import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/core/services/get_it_service.dart';
import 'package:whatsapp/core/utils/app_colors.dart';
import 'package:whatsapp/features/stories/domain/repos/stories_repo.dart';
import 'package:whatsapp/features/stories/presentation/cubits/get_current_stories/get_current_stories_cubit.dart';
import 'package:whatsapp/features/stories/presentation/widgets/show_current_stories_bloc_builder_body.dart';

class StoriesView extends StatelessWidget {
  const StoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetCurrentStoriesCubit(
        storiesRepo: getIt<StoriesRepo>(),
      ),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(
                Icons.edit,
                color: Theme.of(context).iconTheme.color,
                size: 30,
              ),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(
                Icons.camera_alt,
                color: AppColors.primary,
                size: 36,
              ),
              onPressed: () {},
            ),
          ],
        ),
        body: ShowCurrentStoriesBlocBuilderBody(),
      ),
    );
  }
}
