import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:restart_app/restart_app.dart';

class HomeSettings extends StatefulWidget {
  const HomeSettings({
    super.key,
  });

  @override
  State<HomeSettings> createState() => HomeSettingsState();
}

class HomeSettingsState extends State<HomeSettings> {
  late Box appdataBox;
  late String initThemeMode;

  @override
  void initState() {
    super.initState();

    appdataBox = Hive.box("appdata");
    initThemeMode = appdataBox.get("thememode");
  }

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
                      leading: const Icon(Icons.calendar_view_week_rounded),
                      title: const Text("Edit timetable"),
                      minTileHeight: 72,
                      onTap: () => {
                            Navigator.pushNamed(
                                context, "/home/settings/editttb")
                          }),
                  ListTile(
                      leading: const Icon(Icons.color_lens_rounded),
                      title: const Text("Change seed color"),
                      minTileHeight: 72,
                      onTap: () => {
                            Navigator.pushNamed(
                                context, "/home/settings/changeseedcolor")
                          }),
                  ListTile(
                      leading: const Icon(Icons.brightness_4_rounded),
                      minTileHeight: 72,
                      trailing: DropdownMenu(
                          onSelected: (value) {
                            appdataBox.put("thememode", value);
                            showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                      icon:
                                          const Icon(Icons.restart_alt_rounded),
                                      title: const Text("restart"),
                                      content: const Text(
                                          "Do you want to restart the app now, in order to apply the new color mode?"),
                                      actions: [
                                        MaterialButton(
                                          onPressed: () {
                                            Navigator.pop(context, true);
                                          },
                                          child: const Text("No"),
                                        ),
                                        MaterialButton(
                                          onPressed: () {
                                            Restart.restartApp();
                                          },
                                          child: const Text("Yes"),
                                        )
                                      ],
                                    ));
                            // Restart.restartApp();
                          },
                          initialSelection: initThemeMode,
                          dropdownMenuEntries: const [
                            DropdownMenuEntry(value: "dark", label: "dark"),
                            DropdownMenuEntry(value: "light", label: "light"),
                            DropdownMenuEntry(value: "system", label: "system"),
                          ]),
                      title: const Text("Change color mode"),
                      onTap: () => {}),
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
