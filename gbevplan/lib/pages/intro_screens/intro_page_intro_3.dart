import 'package:flutter/material.dart';
import 'package:gbevplan/components/bulletlist.dart';
import 'package:lottie/lottie.dart';

class IntroPageIntro3 extends StatefulWidget {
  const IntroPageIntro3({super.key});

  @override
  State<IntroPageIntro3> createState() => _IntroPageIntro3State();
}

class _IntroPageIntro3State extends State<IntroPageIntro3> {
  final List<Bulletpoint> bulletlist_data = [
    Bulletpoint(text: "Deine Farbe in der App"),
    Bulletpoint(
        text:
            "Ändere die Seedcolor der App in den Einstellung und alles wird sich nach deinem Geschmack richten."),
    Bulletpoint(text: "Mehr persönlichkeit dank Material You"),
  ];
  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
      Container(
        margin: const EdgeInsets.only(top: 128),
        width: 150, // Breite der Animation
        height: 150, // Höhe der Animation
        child: Lottie.network(
            'https://lottie.host/57ba8042-1973-4037-9d03-72682e58b243/2soD1ibMU1.json',
            delegates: LottieDelegates(
              values: [
                // keyPath order: ['layer name', 'group name', 'shape name']
                ValueDelegate.color(const ["**"],
                    value: Theme.of(context)
                        .colorScheme
                        .onSurface), // Hat eigentlich Farbe, kann das aber nicht variable umfärben -> Keine proper light mode detection wenn system im light mode -> immer umfärben F (Effekt geht verloren)
              ],
            ),
            fit: BoxFit.fill),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child:
            Text(style: Theme.of(context).textTheme.displayMedium, "Customize"),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 44),
        child: Bulletlist(
          data: bulletlist_data,
        ),
      )
    ]);
  }
}
