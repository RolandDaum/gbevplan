import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeSettings extends StatefulWidget {
  const HomeSettings({
    super.key,
  });

  @override
  State<HomeSettings> createState() => HomeSettingsState();
}

class HomeSettingsState extends State<HomeSettings> {
  late BuildContext globContext;

  @override
  void deactivate() {
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
          systemOverlayStyle: SystemUiOverlayStyle(
              // If the scafflod uses an appBar, the system Overlay Style has to be declerated in it else just do it over chromeoption thing what ever, befor returning inside the build method
              systemNavigationBarColor: Theme.of(context).colorScheme.surface),
          title: const Text("settings"),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                      enableFeedback: true,
                      leading: const Icon(Icons.calendar_view_week_rounded),
                      title: const Text("Edit timetable"),
                      onTap: () => {
                            Navigator.pushNamed(
                                context, "/home/settings/editttb")
                          }),
                  const Divider(
                    indent: 16,
                    endIndent: 16,
                  ),
                  // ListTile(
                  //   enableFeedback: true,
                  //   // enabled: false,
                  //   leading: const Icon(Icons.contrast_rounded),
                  //   title: const Text("Dark Mode"),
                  //   trailing: Switch(value: true, onChanged: (value) {}),
                  // ),
                  // const Divider(
                  //   indent: 16,
                  //   endIndent: 16,
                  // )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "version 1.0.0",
                style: Theme.of(context).textTheme.labelMedium,
              ),
            )
          ],
        ));
  }
}
