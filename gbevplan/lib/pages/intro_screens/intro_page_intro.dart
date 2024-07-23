import 'package:flutter/material.dart';
import 'package:gbevplan/components/bulletlist.dart';
import 'package:lottie/lottie.dart';

class IntroPageIntro extends StatefulWidget {
  const IntroPageIntro({super.key});

  @override
  State<IntroPageIntro> createState() => _IntroPageIntroState();
}

class _IntroPageIntroState extends State<IntroPageIntro> {
  final List<Bulletpoint> bulletlist_data = [
    Bulletpoint(text: "Direkter zugriff auf deinen persönlichen Stundenplan"),
    Bulletpoint(text: "Automatische Generierung und Aktualisierung"),
    Bulletpoint(text: "Schnelle Information über die aktuelle Stunde")
  ];

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
      Container(
        margin: const EdgeInsets.only(top: 128),
        width: 150, // Breite der Animation
        height: 150, // Höhe der Animation
        child: Lottie.network(
            // TODO: The Animations should be saved locally on device and not only -> TODO: Loading time comparisson
            'https://lottie.host/6837f74c-0023-4e07-8c76-8d8492ff76a7/C3c4XTx9ld.json',
            delegates: LottieDelegates(
              values: [
                // keyPath order: ['layer name', 'group name', 'shape name']
                ValueDelegate.color(const ["**"],
                    value: Theme.of(context).colorScheme.onSurface),
              ],
            ),
            fit: BoxFit.fill),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Text(
            style: Theme.of(context).textTheme.displayMedium, "Stundenplan"),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 44),
        child: Bulletlist(
          data: bulletlist_data,
        ),
      )
    ]);
    ;
  }
}
