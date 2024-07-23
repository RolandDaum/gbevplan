import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:gbevplan/components/empty_widget.dart';
import 'package:hive/hive.dart';

class OldappversionScreen extends StatefulWidget {
  const OldappversionScreen({super.key});

  @override
  State<OldappversionScreen> createState() => _OldappversionScreenState();
}

class _OldappversionScreenState extends State<OldappversionScreen> {
  String localAppversion = "";
  String newestAppversion = "";
  Box appdataBox = Hive.box("appdata");

  @override
  void initState() {
    super.initState();

    localAppversion = appdataBox.get("appversion");
    FirebaseDatabase.instance
        .ref('/data/appversion')
        .once()
        .then((DatabaseEvent event) {
      setState(() {
        newestAppversion = event.snapshot.value as String;
      });
    });
  }

// TODO: On Exit clear storage
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const EmptyWidget(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 128),
                child: Text("App Version",
                    style: Theme.of(context).textTheme.headlineLarge),
              ),
              Text(
                  style: Theme.of(context).textTheme.bodyLarge,
                  "You currently have an outdated AppVersion. Ask the admin for a newer one or if possible update it via Google Playstore or Apple Appstore."),
              const SizedBox(
                height: 48,
              ),
              Text(
                  style: Theme.of(context).textTheme.bodyMedium,
                  "Installed App Version: $localAppversion"),
              const SizedBox(
                height: 16,
              ),
              Text(
                  style: Theme.of(context).textTheme.bodyMedium,
                  "Required App Version: $newestAppversion"),
              const SizedBox(height: 128),
              FilledButton(onPressed: () {}, child: const Text("Exit"))
            ],
          ),
        ),
      ),
    );
  }
}
