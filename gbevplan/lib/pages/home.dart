import 'package:flutter/material.dart';

class page_home extends StatelessWidget {
  const page_home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
      child: Text(
        "H O M E",
        style: Theme.of(context).textTheme.displayLarge,
      ),
    ),
    );
  }
}
