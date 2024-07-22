import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gbevplan/components/empty_widget.dart';
import 'package:gbevplan/pages/home_screens/home_vplan.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final int _selectedIndex = 1;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor:
            Theme.of(context).colorScheme.surfaceContainer));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        onPressed: () => {Navigator.pushNamed(context, "/home/ogtt")},
        enableFeedback: true,
        child: const Icon(Icons.open_in_new_outlined),
      ),
      // primary:
      //     true, // Is nessesary that the body does not get under the system tray
      appBar: const EmptyWidget(), // ^^
      body: const HomeVPlan(),
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
              icon: Icon(Icons.newspaper_rounded), label: "news"),
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
