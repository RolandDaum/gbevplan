import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:restart_app/restart_app.dart';

class Changeseedcolor extends StatefulWidget {
  const Changeseedcolor({super.key});

  @override
  State<Changeseedcolor> createState() => _ChangeseedcolorState();
}

class _ChangeseedcolorState extends State<Changeseedcolor> {
  double redValue = 0;
  double greenValue = 0;
  double blueValue = 0;
  bool loadedSeedColorFromHive = false;
  late Color prevSeedColor;
  // TODO: Add option to load system colors as seed color
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    loadColors();
  }

  void loadColors() {
    var appdataBox = Hive.box("appdata");
    var tmpSeedcolor = appdataBox.get("seedcolor_red");
    if (tmpSeedcolor == null) {
      redValue = Theme.of(context).colorScheme.primary.red.toDouble();
      greenValue = Theme.of(context).colorScheme.primary.green.toDouble();
      blueValue = Theme.of(context).colorScheme.primary.blue.toDouble();

      prevSeedColor = Color.fromRGBO(redValue.round().toInt(),
          greenValue.round().toInt(), blueValue.round().toInt(), 1);
      return;
    }
    redValue = (tmpSeedcolor as int).toDouble();
    greenValue = (appdataBox.get("seedcolor_green") as int).toDouble();
    blueValue = (appdataBox.get("seedcolor_blue") as int).toDouble();

    prevSeedColor = Color.fromRGBO(redValue.round().toInt(),
        greenValue.round().toInt(), blueValue.round().toInt(), 1);
  }

  bool saveSeedColor() {
    Color currentSeedColor = Color.fromRGBO(redValue.round().toInt(),
        greenValue.round().toInt(), blueValue.round().toInt(), 1);
    if (prevSeedColor != currentSeedColor) {
      var appdataBox = Hive.box("appdata");
      appdataBox.put("seedcolor_red", currentSeedColor.red);
      appdataBox.put("seedcolor_blue", currentSeedColor.blue);
      appdataBox.put("seedcolor_green", currentSeedColor.green);
      return true;
    }
    return false;
  }

  void resetColor() {
    loadColors();
    setState(() {
      redValue = prevSeedColor.red.toDouble();
      greenValue = prevSeedColor.green.toDouble();
      blueValue = prevSeedColor.blue.toDouble();
    });
  }

  @override
  void dispose() {
    super.dispose();

    saveSeedColor();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("seed color"),
          actions: [
            IconButton(
                onPressed: () {
                  saveSeedColor() ? Restart.restartApp() : {};
                },
                icon: const Icon(Icons.check_rounded)),
            IconButton(
                onPressed: () {
                  resetColor();
                },
                icon: const Icon(Icons.replay_rounded)),
            IconButton(
                onPressed: () {
                  Hive.box("appdata").delete("seedcolor_red");
                  Hive.box("appdata").delete("seedcolor_green");
                  Hive.box("appdata").delete("seedcolor_blue");
                  resetColor();
                },
                icon: const Icon(
                  Icons.delete_outline_rounded,
                ))
          ],
          systemOverlayStyle: SystemUiOverlayStyle(
              systemNavigationBarColor: Theme.of(context).colorScheme.surface),
        ),
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Padding(
            padding: EdgeInsets.only(left: 25),
            child: Text("Red"),
          ),
          Slider(
            value: redValue,
            min: 0,
            max: 255,
            divisions: 256,
            label: redValue.round().toString(),
            onChanged: (value) => {
              setState(() {
                redValue = value;
              })
            },
          ),
          const Padding(
            padding: EdgeInsets.only(left: 25),
            child: Text("Green"),
          ),
          Slider(
            value: greenValue,
            min: 0,
            max: 255,
            divisions: 256,
            label: greenValue.round().toString(),
            onChanged: (value) => {
              setState(() {
                greenValue = value;
              })
            },
          ),
          const Padding(
            padding: EdgeInsets.only(left: 25),
            child: Text("Blue"),
          ),
          Slider(
            value: blueValue,
            min: 0,
            max: 255,
            divisions: 256,
            label: blueValue.round().toString(),
            onChanged: (value) => {
              setState(() {
                blueValue = value;
              })
            },
          ),
          Container(
            margin: const EdgeInsets.all(25),
            decoration: BoxDecoration(
                color: Color.fromRGBO(redValue.round().toInt(),
                    greenValue.round().toInt(), blueValue.round().toInt(), 1),
                borderRadius: BorderRadius.circular(10)),
            height: 100,
            width: double.infinity,
          ),
        ]));
  }
}
