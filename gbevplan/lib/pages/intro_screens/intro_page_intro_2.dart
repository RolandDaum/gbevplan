import 'package:flutter/material.dart';
import 'package:gbevplan/components/bulletlist.dart';
import 'package:hive/hive.dart';
import 'package:lottie/lottie.dart';

class IntroPageIntro2 extends StatefulWidget {
  const IntroPageIntro2({super.key});

  @override
  State<IntroPageIntro2> createState() => _IntroPageIntro2State();
}

class _IntroPageIntro2State extends State<IntroPageIntro2> {
  final List<Bulletpoint> bulletlist_data = [
    Bulletpoint(
        text:
            "Direkter und schneller Zugriff auf den originalen Vertretungsplan"),
    Bulletpoint(
        text: "Benachrichtigung nach der Veröffentlichung eines neuen VPlans"),
    Bulletpoint(
        text:
            "Mit Einberechnung des VPlans in deinen Stundenplan (coming soon)")
  ];
  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
      Container(
        margin: const EdgeInsets.only(top: 128),
        width: 150, // Breite der Animation
        height: 150, // Höhe der Animation
        child: Lottie.network(
            'https://lottie.host/f63020a2-4b94-4e30-98b8-67eb4080d396/XshSGXvv5Y.json',
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
        child: Text(
            style: Theme.of(context).textTheme.displayMedium,
            "Vertretungsplan"),
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
