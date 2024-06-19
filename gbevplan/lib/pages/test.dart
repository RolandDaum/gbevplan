import 'package:flutter/material.dart';

class PAGE_TEST extends StatelessWidget {
  const PAGE_TEST({super.key});

  @override
  Widget build(BuildContext context) {
    final BUILDmessage = ModalRoute.of(context)?.settings.arguments;

    return Scaffold(
      body: Center(
        child: Text(BUILDmessage != null ? BUILDmessage.toString() : ""),
      ),
    );
  }
}
