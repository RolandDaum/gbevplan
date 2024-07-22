import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gbevplan/components/bulletlist.dart';

class SetupPageIntro extends StatefulWidget {
  const SetupPageIntro({super.key});

  @override
  State<SetupPageIntro> createState() => _SetupPageIntroState();
}

class _SetupPageIntroState extends State<SetupPageIntro>
    with AutomaticKeepAliveClientMixin {
  List<Bulletpoint> dataFeatureBulletlist = [
    Bulletpoint(indent: 0, text: "Display your personal timetable"),
    Bulletpoint(
        indent: 1,
        text:
            "Only for the 12 and 13 grades of the time being, may add other grades on request"),
    Bulletpoint(
        indent: 0,
        text:
            "Access the school timetable in a new, more stylish and convenient way"),
    Bulletpoint(
        indent: 0, text: "Get notified when a new timetable has been released"),
    Bulletpoint(
        indent: 0,
        text: "Change the Color theme just the way you like and want"),
    Bulletpoint(
        indent: 0,
        text: "Be a part of the school community to improve App experience"),
    Bulletpoint(indent: 0, text: "Thank you for your contribution"),
  ];

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 28),
        child: Text(
          "Introduction",
          style: Theme.of(context).textTheme.displayLarge,
        ),
      )
          .animate()
          .fadeIn(begin: -1, duration: const Duration(milliseconds: 750))
          .moveY(
              begin: 300,
              end: 0,
              duration: Durations.long1,
              delay: const Duration(milliseconds: 1250),
              curve: Curves.easeInOutCubic)
          .scale(
              delay: const Duration(milliseconds: 1250),
              begin: const Offset(1, 1),
              end: const Offset(.75, .75),
              curve: Curves.easeInOutCubic),
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 48, vertical: 32),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Feature",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(
              height: 16,
            ),
            Bulletlist(
              data: dataFeatureBulletlist,
            ),
          ],
        ),
      ).animate().fadeIn(
          delay: const Duration(milliseconds: 1250 - 125) + Durations.long1),
    ]);
  }

  @override
  bool get wantKeepAlive => true;
}
