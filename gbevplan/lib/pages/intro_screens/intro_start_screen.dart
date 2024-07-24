import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gbevplan/components/bulletlist.dart';
import 'package:gbevplan/components/empty_widget.dart';
import 'package:gbevplan/pages/intro_screens/intro_page.dart';
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

  final List<Widget> intropages = const [
    IntroPage(
      headling: "Stundenplan",
      bulletlistData: [
        Bulletpoint(
            text: "Direkter Zugriff auf deinen persönlichen Stundenplan"),
        Bulletpoint(text: "Automatische Generierung und Aktualisierung"),
        Bulletpoint(text: "Schnelle Information über die aktuelle Stunde"),
      ],
      lottiAnimationAsset: "assets/lottie/animation_list_growshrink.json",
    ),
    IntroPage(
      headling: "Vertretungsplan",
      bulletlistData: [
        Bulletpoint(
            text:
                "Direkter und schneller Zugriff auf den originalen Vertretungsplan"),
        Bulletpoint(
            text:
                "Benachrichtigung nach der Veröffentlichung eines neuen VPlans"),
        Bulletpoint(
            text:
                "Mit Einberechnung des VPlans in deinen Stundenplan (coming soon)")
      ],
      lottiAnimationAsset: "assets/lottie/animation_list_exchange.json",
    ),
    IntroPage(
      headling: "Customize",
      bulletlistData: [
        Bulletpoint(text: "Deine Farbe in der App"),
        Bulletpoint(
            text:
                "Ändere die Seedcolor der App in den Einstellung und alles wird sich nach deinem Geschmack richten."),
        Bulletpoint(text: "Mehr persönlichkeit dank Material You"),
      ],
      lottiAnimationAsset: "assets/lottie/animation_colorbucket_drop.json",
    ),
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
            margin: const EdgeInsets.symmetric(horizontal: 16),
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