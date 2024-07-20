import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:gbevplan/components/EmptyWidget.dart';
import 'package:gbevplan/tmp.dart';
import 'package:hive/hive.dart';

class Editttb extends StatefulWidget {
  const Editttb({super.key});

  @override
  State<Editttb> createState() => _EditttbState();
}

class _EditttbState extends State<Editttb> {
  late BuildContext globContext;
  TextEditingController tecJahrgangSelection = TextEditingController();
  TextEditingController tecKursSelection = TextEditingController();
  int jahrgang = 0;
  List<String> allekurse = [];
  List<String> selectedKurse = [];

  @override
  void initState() {
    super.initState();

    var appdataBox = Hive.box("appdata");
    var tmp_selectedKurse = appdataBox.get("selectedKurse");
    tmp_selectedKurse != null ? selectedKurse = tmp_selectedKurse : {};
    var tmp_jahrgang = appdataBox.get("jahrgang");
    tmp_jahrgang != null ? jahrgang = tmp_jahrgang : {};

    if (jahrgang == 0) {
      return;
    }

    loadAllCourses();

    // F I R E S T O R E  -  D E M O
    // final data = {
    //   "12_kurse": [
    //     "MA1",
    //     "MA2",
    //     "PH1",
    //     "CH1",
    //     "BI1",
    //     "BI2",
    //     "DE1",
    //     "DE2",
    //     "DE3",
    //     "EN1",
    //     "EN2",
    //     "EN3",
    //     "LA1",
    //     "FR1",
    //     "EK1",
    //     "PW1",
    //     "PW2",
    //     "GE1",
    //     "GE2",
    //     "KU1",
    //     "ma1",
    //     "ma2",
    //     "ma3",
    //     "ma4",
    //     "ph1",
    //     "bi1",
    //     "bi2",
    //     "if1",
    //     "if2",
    //     "ch1",
    //     "de1",
    //     "de2",
    //     "en1",
    //     "en2",
    //     "snn1",
    //     "la1",
    //     "fr1",
    //     "pw1",
    //     "pw2",
    //     "ge1",
    //     "ge2",
    //     "re1",
    //     "re2",
    //     "rk1",
    //     "wn1",
    //     "mu1",
    //     "ku1",
    //     "ds1",
    //     "sp1",
    //     "sp2",
    //     "sp3",
    //     "sp4",
    //     "spp1",
    //     "sf1",
    //     "sf2",
    //     "sf3",
    //     "sf4",
    //     "sf5",
    //     "sf6"
    //   ]
    // };
    // final data2 = {"test": true};
    // final db = FirebaseFirestore.instance;
    // // db.databaseId = "database";
    // // db.settings = const Settings(persistenceEnabled: true);
    // db.collection("2023-24-2").doc("oberstufe").get().then((onValue) => {
    //       onValue.data()?.forEach((key, value) {
    //         print(key);
    //         print(value);
    //       })
    //     });
    // // db.collection("2023-24-2").doc("oberstufe").set(data2);
    // db.collection("2023-24-2").doc("oberstufe").get().then((onValue) => {
    //       onValue.data()?.forEach((key, value) {
    //         print(key);
    //         print(value);
    //       })
    //     });
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
          .doc("oberstufe")
          .get()
          .then((value) => {
                setState(() {
                  allekurse = value.data()?["${jahrgang}_kurse"].cast<String>();
                  selectedKurse.isNotEmpty
                      ? selectedKurse.forEach((kurs) {
                          if (allekurse.contains(kurs)) {
                            allekurse.remove(kurs);
                          }
                        })
                      : {};
                })
              });
    });
  }

  @override
  void dispose() {
    super.dispose();

    var appdataBox = Hive.box("appdata");
    appdataBox.put("jahrgang", jahrgang);
    appdataBox.put("selectedKurse", selectedKurse);
  }

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
          scrolledUnderElevation: 0,
          title: const Text("Edit Timetable"),
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
                  padding: const EdgeInsets.symmetric(horizontal: 25),
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
                            const Divider(
                              indent: 16,
                              endIndent: 16,
                            ),
                          ],
                        );
                      }),
                ))
              : EmptyWidget()
        ]));
  }
}

//Padding(
//   padding: const EdgeInsets.symmetric(
//       vertical: 10, horizontal: 40),
//   child: Row(
//     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//     children: [
//       Text(selectedKurse[index]),
//       GestureDetector(
//         child: const Icon(Icons.close_rounded),
//         onTap: () {
//           setState(() {
//             allekurse.add(selectedKurse[index]);
//             selectedKurse.removeAt(index);
//           });
//         },
//       )
//     ],
//   ),
// );
