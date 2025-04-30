import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:whatsapp/core/utils/app_routes.dart';
import 'package:whatsapp/core/widgets/undefined_route_page.dart';
import 'package:whatsapp/features/auth/presentation/screens/signin_screen.dart';
import 'package:whatsapp/features/auth/presentation/screens/signup_screen.dart';
import 'package:whatsapp/features/auth/presentation/screens/verify_otp_screen.dart';
import 'package:whatsapp/features/home/presentation/screens/home_screen.dart';

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
    default:
      return MaterialPageRoute(
        builder: (context) => const UndefinedRoutePage(),
      );
  }
}
