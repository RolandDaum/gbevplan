import 'package:flutter/material.dart';
import 'package:gbevplan/Objects/timetable.dart';
import 'package:gbevplan/components/bulletlist.dart';
import 'package:gbevplan/components/empty_widget.dart';
import 'package:gbevplan/pages/intro_screens/intro_page.dart';
import 'package:gbevplan/pages/setup_screens/setup_page_courseselection.dart';
import 'package:gbevplan/pages/setup_screens/setup_page_jahrgangselection.dart';
import 'package:hive/hive.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SetupStartScreen extends StatefulWidget {
  const SetupStartScreen({super.key});

  @override
  State<SetupStartScreen> createState() => _SetupStartScreenState();
}

class _SetupStartScreenState extends State<SetupStartScreen> {
  Box appdataBox = Hive.box("appdata");
  int _currentpage = 0;
  final PageController _controller = PageController();
  final List<Widget> setuppages = [
    const IntroPage(
        headling: "Einrichtung",
        lottiAnimationAsset: "assets/lottie/animation_settings_rotating.json",
        bulletlistData: [
          Bulletpoint(
              text:
                  "Um die App im kompletten Umfang zu nutzen braucht sie einige schulische Informationen über dich."),
          Bulletpoint(
              text:
                  "Alle eingegebenen Daten werden ausschließlich nur in der App lokal auf deinem Endgerät gespeichert."),
          Bulletpoint(
              text:
                  "Alle erfassten Daten werden nur zum Anzeigen, Berechnen und zur lokalen Verarbeitung genutzt")
        ]),
    const SetupPageJahrgangselection(),
    const SetupPageCourseselection()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          const EmptyWidget(), // Else the body will clip behind the status bar
      extendBody: false,
      extendBodyBehindAppBar: false,
      body: Stack(alignment: Alignment.bottomCenter, children: [
        PageView(
          onPageChanged: (value) {
            setState(() {
              _currentpage = value;
            });
          },
          controller: _controller,
          children: setuppages,
        ),
        // TODO: Once true the ui becomes unuseable with an open keyboard.
        MediaQuery.of(context).viewInsets.bottom == 0
            ? Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SmoothPageIndicator(
                    controller: _controller,
                    count: setuppages.length,
                    effect: ExpandingDotsEffect(
                        dotHeight: 8,
                        dotWidth: 8,
                        dotColor:
                            Theme.of(context).colorScheme.onSurfaceVariant,
                        activeDotColor:
                            Theme.of(context).colorScheme.onSurface),
                    onDotClicked: (value) {
                      _controller.animateToPage(value,
                          duration: Durations.medium1, curve: Curves.easeInOut);
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 32, horizontal: 24),
                    child: FilledButton(
                        onPressed: () {
                          if (_currentpage != setuppages.length - 1) {
                            switch (_currentpage) {
                              case 1:
                                if (appdataBox.get("jahrgang") >= 5) {
                                  _controller.animateToPage(
                                      _controller.page!.toInt() + 1,
                                      duration: Durations.medium1,
                                      curve: Curves.easeInOut);
                                } else {
                                  // TODO: add bottom pop up notification thing, if no grade has been selected
                                }
                                break;
                              default:
                                _controller.animateToPage(
                                    _controller.page!.toInt() + 1,
                                    duration: Durations.medium1,
                                    curve: Curves.easeInOut);
                                break;
                            }
                          } else {
                            if (appdataBox.get("jahrgang") >= 5) {
                              // TODO Proper save data method
                              appdataBox.put("initBoot", false);
                              Timetable.createTimetable().then((value) {
                                Navigator.pushReplacementNamed(
                                    // TODO: Add loading screen -> for calculating personal timetable
                                    context,
                                    "/home");
                              });
                            }
                          }
                        },
                        child: Container(
                            alignment: Alignment.center,
                            width: 150,
                            child: _currentpage != setuppages.length - 1
                                ? const Text("weiter")
                                : const Text("fertig"))),
                  ),
                ],
              )
            : const EmptyWidget()
      ]),
    );
  }
}

// var appdataBOX = Hive.box("appdata");
// appdataBOX.put("initBoot", false);
