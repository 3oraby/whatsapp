import 'package:flutter/material.dart';
import 'package:whatsapp/core/utils/app_routes.dart';
import 'package:whatsapp/core/widgets/undefined_route_page.dart';
import 'package:whatsapp/features/auth/presentation/screens/signin_screen.dart';
import 'package:whatsapp/features/auth/presentation/screens/signup_screen.dart';

Route<dynamic> onGenerateRoutes(RouteSettings settings) {
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
    default:
      return MaterialPageRoute(
        builder: (context) => const UndefinedRoutePage(),
      );
  }
}
