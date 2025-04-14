import 'package:flutter/material.dart';

class UndefinedRoutePage extends StatelessWidget {
  const UndefinedRoutePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("No Route Found"),
      ),
      body: Center(
        child: Text("wrong route page"),
      ),
    );
  }
}
