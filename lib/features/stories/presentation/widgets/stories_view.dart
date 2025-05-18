import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/core/services/get_it_service.dart';
import 'package:whatsapp/features/stories/domain/repos/stories_repo.dart';
import 'package:whatsapp/features/stories/presentation/cubits/create_new_story/create_new_story_cubit.dart';
import 'package:whatsapp/features/stories/presentation/cubits/get_current_stories/get_current_stories_cubit.dart';
import 'package:whatsapp/features/stories/presentation/widgets/show_current_stories_bloc_builder_body.dart';

class StoriesView extends StatelessWidget {
  const StoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => GetCurrentStoriesCubit(
            storiesRepo: getIt<StoriesRepo>(),
          ),
        ),
        BlocProvider(
          create: (_) => CreateNewStoryCubit(
            storiesRepo: getIt<StoriesRepo>(),
          ),
        ),
      ],
      child: Scaffold(
        
        body: ShowCurrentStoriesBlocBuilderBody(),
      ),
    );
  }
}
