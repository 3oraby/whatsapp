import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/core/utils/app_routes.dart';
import 'package:whatsapp/core/widgets/undefined_route_page.dart';
import 'package:whatsapp/features/auth/presentation/screens/set_user_profile_picture_screen.dart';
import 'package:whatsapp/features/auth/presentation/screens/signin_screen.dart';
import 'package:whatsapp/features/auth/presentation/screens/signup_screen.dart';
import 'package:whatsapp/features/auth/presentation/screens/verify_otp_screen.dart';
import 'package:whatsapp/features/chats/domain/entities/chat_screen_args.dart';
import 'package:whatsapp/features/chats/presentation/screens/chat_screen.dart';
import 'package:whatsapp/features/contacts/presentation/screens/add_new_contacts_screen.dart';
import 'package:whatsapp/features/home/presentation/screens/home_screen.dart';
import 'package:whatsapp/features/stories/presentation/cubits/create_new_story/create_new_story_cubit.dart';
import 'package:whatsapp/features/stories/presentation/routes/create_new_story_args.dart';
import 'package:whatsapp/features/stories/presentation/routes/user_stories_viewer_args.dart';
import 'package:whatsapp/features/stories/presentation/screens/create_new_story_screen.dart';
import 'package:whatsapp/features/stories/presentation/screens/create_story_image_preview_screen.dart';
import 'package:whatsapp/features/stories/presentation/screens/user_stories_viewer_screen.dart';
import 'package:whatsapp/features/user/domain/entities/user_entity.dart';
import 'package:whatsapp/features/user/presentation/screens/full_user_profile_img_screen.dart';
import 'package:whatsapp/features/user/presentation/screens/user_profile_screen.dart';

Route<dynamic> onGenerateRoutes(RouteSettings settings) {
  log("Navigating to ${settings.name}");

  switch (settings.name) {
    case Routes.signInRoute:
      return MaterialPageRoute(
        builder: (context) => SignInScreen(),
      );
    case Routes.signUpRoute:
      return MaterialPageRoute(
        builder: (context) => SignUpScreen(),
      );
    case Routes.homeRoute:
      return MaterialPageRoute(
        builder: (context) => HomeScreen(),
      );
    case Routes.verifyOtpRoute:
      return MaterialPageRoute(
        builder: (context) => VerifyOtpScreen(),
      );
    case Routes.addNewContactsRoute:
      return MaterialPageRoute(
        builder: (context) => AddNewContactsScreen(),
      );
    case Routes.createNewStoryRoute:
      final args = settings.arguments as CreateNewStoryArgs;
      return MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: args.cubit,
          child: CreateNewStoryScreen(
            initialTab: args.initialTab,
          ),
        ),
      );
    case Routes.createStoryImagePreviewRoute:
      final CreateNewStoryCubit createNewStoryCubit =
          settings.arguments as CreateNewStoryCubit;
      return MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: createNewStoryCubit,
          child: CreateStoryImagePreviewScreen(),
        ),
      );
    case Routes.userStoriesViewerRoute:
      final args = settings.arguments as UserStoriesViewerArgs;
      return MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: args.cubit,
          child: UserStoriesViewerScreen(
            showCurrentUserStories: args.showCurrentUserStories,
          ),
        ),
      );

    case Routes.chatScreenRoute:
      final ChatScreenArgs chat = settings.arguments as ChatScreenArgs;
      return MaterialPageRoute(
        builder: (_) => ChatScreen(
          chatScreenArgs: chat,
        ),
      );

    case Routes.setUserProfileImgRoute:
      final isInSignUpStep = settings.arguments as bool? ?? true;

      return MaterialPageRoute(
        builder: (context) => SetUserProfilePictureScreen(
          isInSignUpStep: isInSignUpStep,
        ),
      );

    case Routes.userProfileRoute:
      final user = settings.arguments as UserEntity;
      return MaterialPageRoute(
        builder: (_) => UserProfileScreen(user: user),
      );

    case Routes.fullUserProfileImgRoute:
      final arguments = settings.arguments as Map;
      return MaterialPageRoute(
        builder: (_) => FullUserProfileImgScreen(
          imagePath: arguments['imagePath'],
          heroTag: arguments['heroTag'],
        ),
      );

    default:
      return MaterialPageRoute(
        builder: (context) => const UndefinedRoutePage(),
      );
  }
}
