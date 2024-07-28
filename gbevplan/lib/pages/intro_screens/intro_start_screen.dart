import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gbevplan/components/bulletlist.dart';
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
      extendBody: false,
      extendBodyBehindAppBar: false,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
                _animatePage(value);
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 0),
              child: FilledButton(
                  onPressed: () {
                    if (_currentpage != intropages.length - 1) {
                      _animatePage(_currentpage + 1);
                    } else {
                      Navigator.pushReplacementNamed(context, "/setupstart");
                    }
                  },
                  child: Container(
                      alignment: Alignment.center,
                      width: 150,
                      child: _currentpage != intropages.length - 1
                          ? const Text("weiter")
                          : const Text("einrichtung"))),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
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
                    Navigator.pushReplacementNamed(context, "/setupstart");
                  },
                  child: const Text("überspringen"))),
        ],
      ),
    );
  }
}

// var appdataBOX = Hive.box("appdata");
// appdataBOX.put("initBoot", false);