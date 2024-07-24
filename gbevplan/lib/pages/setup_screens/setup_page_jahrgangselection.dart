import 'package:flutter/material.dart';
import 'package:gbevplan/components/jahrgangs_selection.dart';
import 'package:lottie/lottie.dart';

class SetupPageJahrgangselection extends StatefulWidget {
  const SetupPageJahrgangselection({super.key});

  @override
  State<SetupPageJahrgangselection> createState() =>
      _SetupPageJahrgangselectionState();
}

class _SetupPageJahrgangselectionState
    extends State<SetupPageJahrgangselection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 128),
          width: 150,
          height: 150,
          child: Lottie.asset("assets/lottie/animation_list_scrollthrough.json",
              delegates: LottieDelegates(
                values: [
                  // keyPath order: ['layer name', 'group name', 'shape name']
                  ValueDelegate.color(const ["**", "**", "**"],
                      value: Theme.of(context).colorScheme.onSurface),
                ],
              ),
              fit: BoxFit.fill),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 54),
          child: Text(
            "Jahrgang",
            style: Theme.of(context).textTheme.displayMedium,
          ),
        ),
        const Jahrgangsselection()
      ],
    );
  }
}
