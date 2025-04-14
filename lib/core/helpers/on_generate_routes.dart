import 'package:flutter/material.dart';
import 'package:whatsapp/core/widgets/undefined_route_page.dart';

Route<dynamic> onGenerateRoutes(RouteSettings settings) {
  switch (settings.name) {
    // case CheckoutView.routeName:
    //   return MaterialPageRoute(
    //       builder: (context) => CheckoutView(
    //             cartEntity: settings.arguments as CartEntity,
    //           ));
    default:
      return MaterialPageRoute(
        builder: (context) => const UndefinedRoutePage(),
      );
  }
}
