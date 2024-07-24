import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gbevplan/Objects/timetable.dart';
import 'package:gbevplan/components/empty_widget.dart';
import 'package:hive/hive.dart';

class Editttb extends StatefulWidget {
  const Editttb({super.key});

  @override
  State<Editttb> createState() => _EditttbState();
}

class _EditttbState extends State<Editttb> {
  TextEditingController tecJahrgangSelection = TextEditingController();
  TextEditingController tecKursSelection = TextEditingController();
  int jahrgang = 0;
  List<String> allekurse = [];
  List<String> selectedKurse = [];
  Box appdataBox = Hive.box("appdata");

  @override
  void initState() {
    super.initState();

    var appdataBox = Hive.box("appdata");
    var tmpSelectedkurse = appdataBox.get("selectedKurse");
    tmpSelectedkurse != null ? selectedKurse = tmpSelectedkurse : {};
    var tmpJahrgang = appdataBox.get("jahrgang");
    tmpJahrgang != null ? jahrgang = tmpJahrgang : {};

    if (jahrgang == 0) {
      return;
    }

    loadAllCourses();
  }

  void loadAllCourses() {
    FirebaseDatabase.instance
        .ref('/data/ttbyear')
        .once()
        .then((DatabaseEvent event) {
      final db = FirebaseFirestore.instance;
      db.databaseId = "database";
      db
          .collection(event.snapshot.value as String)
          .doc(jahrgang.toString())
          .get()
          .then((value) {
        allekurse = value.data()!["all_courses"].cast<String>();
        for (var kurs in selectedKurse) {
          allekurse.remove(kurs);
        }
        setState(() {
          allekurse;
        });
      });
    });
  }

  @override
  void dispose() {
    super.dispose();

    appdataBox.put("jahrgang", jahrgang);
    appdataBox.put("selectedKurse", selectedKurse);
    Timetable.createTimetable();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("edit timetable"),
          systemOverlayStyle: SystemUiOverlayStyle(
              systemNavigationBarColor: Theme.of(context).colorScheme.surface),
        ),
        body: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: DropdownMenu(
              dropdownMenuEntries: const [
                DropdownMenuEntry<int>(
                    value: 5, label: "Jahrgang 5", enabled: false),
                DropdownMenuEntry<int>(
                    value: 6, label: "Jahrgang 6", enabled: false),
                DropdownMenuEntry<int>(
                    value: 7, label: "Jahrgang 7", enabled: false),
                DropdownMenuEntry<int>(
                    value: 8, label: "Jahrgang 8", enabled: false),
                DropdownMenuEntry<int>(
                    value: 9, label: "Jahrgang 9", enabled: false),
                DropdownMenuEntry<int>(
                    value: 10, label: "Jahrgang 10", enabled: false),
                DropdownMenuEntry<int>(
                    value: 11, label: "Jahrgang 11", enabled: false),
                DropdownMenuEntry<int>(
                    value: 12, label: "Jahrgang 12", enabled: true),
                DropdownMenuEntry<int>(
                    value: 13, label: "Jahrgang 13", enabled: false),
              ],
              width: 250,
              menuHeight: 200,
              controller: tecJahrgangSelection,
              label: const Text("Jahrgang"),
              enableSearch: false,
              enableFilter: false,
              requestFocusOnTap: false,
              initialSelection: jahrgang != 0 ? jahrgang : null,
              onSelected: (value) {
                setState(() {
                  jahrgang = value!;
                  selectedKurse.clear();
                  loadAllCourses();
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: DropdownMenu(
              dropdownMenuEntries:
                  allekurse.map<DropdownMenuEntry<String>>((String value) {
                return DropdownMenuEntry<String>(
                  value: value,
                  label: value,
                );
              }).toList(),
              width: 250,
              menuHeight: 200,
              controller: tecKursSelection,
              label: const Text("Kurse"),
              enableSearch: true,
              enableFilter: true,
              requestFocusOnTap: true,
              onSelected: (value) {
                setState(() {
                  allekurse.remove(value);
                  selectedKurse.add(value!);
                  tecKursSelection.text = "";
                });
              },
            ),
          ),
          jahrgang != 0
              ? Expanded(
                  child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 34),
                  child: ListView.builder(
                      itemCount: selectedKurse.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            ListTile(
                              trailing: GestureDetector(
                                child: const Icon(Icons.close_rounded),
                                onTap: () {
                                  setState(() {
                                    allekurse.add(selectedKurse[index]);
                                    selectedKurse.removeAt(index);
                                  });
                                },
                              ),
                              title: Text(selectedKurse[index]),
                            ),
                            index != selectedKurse.length - 1
                                ? const Divider(
                                    height: 2,
                                  )
                                : const EmptyWidget()
                          ],
                        );
                      }),
                ))
              : const EmptyWidget()
        ]));
  }
}
