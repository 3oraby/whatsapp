import 'package:flutter/material.dart';
import 'package:whatsapp/core/widgets/custom_bottom_navigation_bar.dart';
import 'package:whatsapp/features/home/presentation/widgets/home_body.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentViewIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomBottomNavigationBar(
        onTabChange: (value) {
          setState(() {
            currentViewIndex = value;
          });
        },
      ),
      body: HomeBody(currentViewIndex: currentViewIndex),
    );
  }
}
