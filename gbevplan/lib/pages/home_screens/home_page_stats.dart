import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:gbevplan/tmp.dart';
// import 'package:lottie/lottie.dart';

// ignore: camel_case_types
class HomePageStats extends StatefulWidget {
  const HomePageStats({super.key});

  @override
  State<HomePageStats> createState() => _HomePageStatsState();
}

// ignore: camel_case_types
class _HomePageStatsState extends State<HomePageStats> {
  @override
  void deactivate() {
    super.deactivate();

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor:
            Theme.of(context).colorScheme.surfaceContainer));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("stats"),
        systemOverlayStyle: SystemUiOverlayStyle(
            systemNavigationBarColor: Theme.of(context).colorScheme.surface),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              " S T A T S", // Change to school stats e.g. how many lessons are left this day/week/month/year etc.
              style: Theme.of(context).textTheme.displayMedium,
            ),
            Text(
              "{ comming soon }", // Change to school stats e.g. how many lessons are left this day/week/month/year etc.
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
