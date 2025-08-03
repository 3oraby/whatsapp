import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/core/cubit/save_media_cubit/save_media_cubit.dart';
import 'package:whatsapp/core/helpers/show_custom_snack_bar.dart';
import 'package:whatsapp/core/widgets/custom_bottom_navigation_bar.dart';
import 'package:whatsapp/features/home/presentation/widgets/home_body.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentViewIndex = 1;

  @override
  Widget build(BuildContext context) {
    return BlocListener<SaveMediaCubit, SaveMediaState>(
      listener: (context, state) {
        if (state is SaveMediaSuccess) {
          showCustomSnackBar(context, "Saved to gallery");
        } else if (state is SaveMediaFailure) {
          showCustomSnackBar(context, state.message);
        }
      },
      child: Scaffold(
        bottomNavigationBar: CustomBottomNavigationBar(
          currentViewIndex: currentViewIndex,
          onTabChange: (value) {
            setState(() {
              currentViewIndex = value;
            });
          },
        ),
        body: HomeBody(
          currentViewIndex: currentViewIndex,
        ),
      ),
    );
  }
}
