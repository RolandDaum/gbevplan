import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gbevplan/pages/home_screens/home_page_vplan.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final int _selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    // TODO: Add toggle for notifications
    return Scaffold(
      extendBody: true,
      floatingActionButton: FloatingActionButton(
        onPressed: () => {Navigator.pushNamed(context, "/home/ogtt")},
        enableFeedback: true,
        child: const Icon(Icons.open_in_new_outlined),
      ),
      appBar: AppBar(
        toolbarHeight: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
            systemNavigationBarColor:
                Theme.of(context).colorScheme.surfaceContainer),
      ),
      body: const HomePageVplan(),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (value) => {
          setState(() {
            switch (value) {
              case 0:
                Navigator.of(context).pushNamed("/home/news");
                break;
              case 1:
                break;
              case 2:
                Navigator.of(context).pushNamed("/home/settings");
                break;
            }
          })
        },
        selectedIndex: _selectedIndex,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.pie_chart_rounded), label: "stats"),
          NavigationDestination(
              icon: Icon(Icons.view_list_rounded), label: "vplan"),
          NavigationDestination(
              icon: Icon(
                Icons.settings_rounded,
              ),
              label: "settings")
        ],
      ),
    );
  }
}
