import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gbevplan/tmp.dart';
import 'package:lottie/lottie.dart';

// ignore: camel_case_types
class HomeNews extends StatefulWidget {
  const HomeNews({super.key});

  @override
  State<HomeNews> createState() => HomeNewsState();
}

// ignore: camel_case_types
class HomeNewsState extends State<HomeNews> {
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
        title: const Text("news"),
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
            const SizedBox(
              height: 20,
            ),
            FilledButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/introstart");
                },
                child: const Text("Introduction Screen")),
            FilledButton(
                onPressed: () {
                  // transfareData();
                },
                child: const Text("Transfare Data")),
            FilledButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      // barrierDismissible: false,
                      builder: (_) => Container(
                            height: 60,
                            width: 60,
                            child: Lottie.asset(
                              "assets/lottie/animation_loading_circle.json",
                              delegates: LottieDelegates(
                                values: [
                                  // keyPath order: ['layer name', 'group name', 'shape name']
                                  ValueDelegate.color(const ["**", "**", "**"],
                                      value: Theme.of(context)
                                          .colorScheme
                                          .onSurface),
                                ],
                              ),
                            ),
                          ));
                },
                child: const Text("showdialog"))
          ],
        ),
      ),
    );
  }
}
