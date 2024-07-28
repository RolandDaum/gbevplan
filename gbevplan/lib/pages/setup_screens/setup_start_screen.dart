import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gbevplan/Objects/timetable.dart';
import 'package:gbevplan/components/bulletlist.dart';
import 'package:gbevplan/pages/intro_screens/intro_page.dart';
import 'package:gbevplan/pages/setup_screens/setup_page_courseselection.dart';
import 'package:gbevplan/pages/setup_screens/setup_page_jahrgangselection.dart';
import 'package:hive/hive.dart';
import 'package:lottie/lottie.dart';
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
  void initState() {
    super.initState();
  }

  void _animatePage(int pageINT) {
    _controller.animateToPage(pageINT,
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SmoothPageIndicator(
              controller: _controller,
              count: setuppages.length,
              effect: ExpandingDotsEffect(
                  dotHeight: 8,
                  dotWidth: 8,
                  dotColor: Theme.of(context).colorScheme.onSurfaceVariant,
                  activeDotColor: Theme.of(context).colorScheme.onSurface),
              onDotClicked: (value) {
                _animatePage(value);
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 0),
              child: FilledButton(
                  onPressed: () {
                    if (_currentpage != setuppages.length - 1) {
                      _controller.animateToPage(_controller.page!.toInt() + 1,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut);
                    } else {
                      if (appdataBox.get("jahrgang") >= 5) {
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (_) => PopScope(
                                  canPop: false,
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                        sigmaX: 10, sigmaY: 10),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: SizedBox(
                                        height: 150,
                                        width: 150,
                                        child: Lottie.asset(
                                          "assets/lottie/animation_loading_circle.json",
                                          delegates: LottieDelegates(
                                            values: [
                                              // keyPath order: ['layer name', 'group name', 'shape name']
                                              ValueDelegate.color(
                                                  const ["**", "**", "**"],
                                                  value: Theme.of(context)
                                                      .colorScheme
                                                      .onSurface),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )); // TODO Proper save data method
                        Timetable.createTimetable().then((value) {
                          appdataBox.put("initBoot", false);
                          Navigator.pop(context);
                          Navigator.pushReplacementNamed(context, "/home");
                        });
                      } else {
                        Fluttertoast.showToast(
                          msg: "kein Jahrgang ausgewählt",
                          toastLength: Toast.LENGTH_SHORT,
                          backgroundColor:
                              Theme.of(context).colorScheme.errorContainer,
                          textColor:
                              Theme.of(context).colorScheme.onErrorContainer,
                        );
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
        ),
      ),
      extendBody: false,
      extendBodyBehindAppBar: false,
      body: Stack(
        children: [
          PageView(
            onPageChanged: (value) {
              setState(() {
                _currentpage = value;
              });
            },
            controller: _controller,
            children: setuppages,
          ),
        ],
      ),
    );
  }
}
