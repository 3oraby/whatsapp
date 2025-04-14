import 'package:flutter/material.dart';

class SizeConfig {
  static const double desktopBreakPoint = 1200;
  static const double tabletBreakPoint = 800;

  // but mediaQuery make rebuild for ui when use it  
  static late double screenHeight, screenWidth;

  static void init(BuildContext context) {
    screenHeight = MediaQuery.sizeOf(context).height;
    screenWidth = MediaQuery.sizeOf(context).width;
  }
}
