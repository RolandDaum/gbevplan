import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore: camel_case_types
class HomeNews extends StatefulWidget {
  const HomeNews({super.key});

  @override
  State<HomeNews> createState() => HomeNewsState();
}

// ignore: camel_case_types
class HomeNewsState extends State<HomeNews> {
  late BuildContext globContext;

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor:
            Theme.of(globContext).colorScheme.surfaceContainer));
  }

  @override
  Widget build(BuildContext context) {
    globContext = context;
    return Scaffold(
      appBar: AppBar(
        title: const Text("news"),
        systemOverlayStyle: SystemUiOverlayStyle(
            systemNavigationBarColor: Theme.of(context).colorScheme.surface),
      ),
      body: Center(
        child: Text(
          "N E W S",
          style: Theme.of(context).textTheme.displayMedium,
        ),
      ),
    );
  }
}
