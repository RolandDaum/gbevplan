import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gbevplan/components/empty_widget.dart';
import 'package:gbevplan/pages/intro_screens/intro_page_intro_2.dart';
import 'package:gbevplan/pages/intro_screens/intro_page_intro.dart';
import 'package:gbevplan/pages/intro_screens/intro_page_intro_3.dart';
import 'package:hive/hive.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class IntroStartScreen extends StatefulWidget {
  const IntroStartScreen({super.key});

  @override
  State<IntroStartScreen> createState() => _IntroStartScreenState();
}

class _IntroStartScreenState extends State<IntroStartScreen> {
  Box appdataBox = Hive.box("appdata");
  final PageController _controller = PageController();
  int _currentpage = 0;

  final List<Widget> intropages = [
    const IntroPageIntro(),
    const IntroPageIntro2(),
    const IntroPageIntro3(),
  ];

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  }

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
          children: intropages,
        ),
        Container(
            alignment: Alignment.topRight,
            child: TextButton(
                onPressed: () {
                  // ToDo: Add skip functionallity
                },
                child: const Text("Skip"))),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SmoothPageIndicator(
              controller: _controller,
              count: intropages.length,
              effect: ExpandingDotsEffect(
                  dotHeight: 8,
                  dotWidth: 8,
                  dotColor: Theme.of(context).colorScheme.onSurfaceVariant,
                  activeDotColor: Theme.of(context).colorScheme.onSurface),
              onDotClicked: (value) {
                _controller.animateToPage(value,
                    duration: Durations.medium1, curve: Curves.easeInOut);
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
              child: FilledButton(
                  onPressed: () {
                    if (_currentpage != intropages.length - 1) {
                      _controller.animateToPage(_controller.page!.toInt() + 1,
                          duration: Durations.medium1, curve: Curves.easeInOut);
                    } else {
                      appdataBox.put("initBoot", false);
                      Navigator.pushReplacementNamed(context, "/home");
                    }
                  },
                  child: Container(
                      alignment: Alignment.center,
                      width: 150,
                      child: _currentpage != intropages.length - 1
                          ? const Text("Continue")
                          : const Text("Setup"))),
            ),
          ],
        )
      ]),
    );
  }
}

// var appdataBOX = Hive.box("appdata");
// appdataBOX.put("initBoot", false);