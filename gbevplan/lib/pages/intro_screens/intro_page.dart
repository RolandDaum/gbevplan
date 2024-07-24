import 'package:flutter/material.dart';
import 'package:gbevplan/components/bulletlist.dart';
import 'package:lottie/lottie.dart';

class IntroPage extends StatelessWidget {
  final String lottiAnimationAsset;
  final String headling;
  final List<Bulletpoint> bulletlistData;

  const IntroPage({
    super.key,
    this.headling = "Headline",
    this.bulletlistData = const [
      Bulletpoint(
          text:
              "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam"),
      Bulletpoint(
          text:
              "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam"),
      Bulletpoint(
          text:
              "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam")
    ],
    this.lottiAnimationAsset = "assets/lottie/animation_loading_circle.json",
  });

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
      Container(
        margin: const EdgeInsets.only(top: 128),
        width: 150,
        height: 150,
        child: Lottie.asset(lottiAnimationAsset,
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
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Text(style: Theme.of(context).textTheme.displayMedium, headling),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 44),
        child: Bulletlist(
          data: bulletlistData,
        ),
      )
    ]);
    ;
  }
}
