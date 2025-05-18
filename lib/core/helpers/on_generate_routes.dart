import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/core/utils/app_routes.dart';
import 'package:whatsapp/core/widgets/undefined_route_page.dart';
import 'package:whatsapp/features/auth/presentation/screens/signin_screen.dart';
import 'package:whatsapp/features/auth/presentation/screens/signup_screen.dart';
import 'package:whatsapp/features/auth/presentation/screens/verify_otp_screen.dart';
import 'package:whatsapp/features/contacts/presentation/screens/add_new_contacts_screen.dart';
import 'package:whatsapp/features/home/presentation/screens/home_screen.dart';
import 'package:whatsapp/features/stories/presentation/cubits/create_new_story/create_new_story_cubit.dart';
import 'package:whatsapp/features/stories/presentation/screens/create_new_story_screen.dart';
import 'package:whatsapp/features/stories/presentation/screens/create_story_image_preview_screen.dart';

Route<dynamic> onGenerateRoutes(RouteSettings settings) {
  log("Navigating to ${settings.name}");

  switch (settings.name) {
    // case CheckoutView.routeName:
    //   return MaterialPageRoute(
    //       builder: (context) => CheckoutView(
    //             cartEntity: settings.arguments as CartEntity,
    //           ));
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
      final CreateNewStoryCubit createNewStoryCubit =
          settings.arguments as CreateNewStoryCubit;
      return MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: createNewStoryCubit,
          child: CreateNewStoryScreen(),
        ),
      );
    case Routes.createStoryImagePreviewRoute:
      final CreateNewStoryCubit createNewStoryCubit =
          settings.arguments as CreateNewStoryCubit;
      return MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: createNewStoryCubit,
          child: CreateStoryImagePreviewScreen(
            createNewStoryCubit: createNewStoryCubit,
          ),
        ),
      );
    default:
      return MaterialPageRoute(
        builder: (context) => const UndefinedRoutePage(),
      );
  }
}
