import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class SetupTuto extends StatefulWidget {
  const SetupTuto({super.key});

  @override
  State<SetupTuto> createState() => _SetupTutoState();
}

class _SetupTutoState extends State<SetupTuto> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: MaterialButton(
          color: Theme.of(context).colorScheme.primary,
          onPressed: () {
            var appdataBOX = Hive.box("appdata");
            appdataBOX.put("initBoot", false);
          }),
    );
  }
}
