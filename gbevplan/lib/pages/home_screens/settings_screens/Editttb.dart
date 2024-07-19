import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Editttb extends StatefulWidget {
  const Editttb({super.key});

  @override
  State<Editttb> createState() => _EditttbState();
}

class _EditttbState extends State<Editttb> {
  late BuildContext globContext;
  late List<DropdownMenuEntry<String>> dropdownentry;
  List<String> allekurse = [];
  List<String> selectedKurse = [];

  @override
  void initState() {
    super.initState();

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
                  allekurse = value.data()?["12_kurse"].cast<String>();
                })
              });
    });
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
          title: const Text("Edit Timetable"),
          systemOverlayStyle: SystemUiOverlayStyle(
              systemNavigationBarColor: Theme.of(context).colorScheme.surface),
        ),
        body: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          DropdownMenu(
            width: 250,
            dropdownMenuEntries:
                allekurse.map<DropdownMenuEntry<String>>((String value) {
              return DropdownMenuEntry<String>(
                value: value,
                label: value,
              );
            }).toList(),
            menuHeight: 200,
            menuStyle: const MenuStyle(),
            label: Text("Kurse"),
            enableSearch: true,
            enableFilter: true,
            controller: TextEditingController(),
            requestFocusOnTap: true,
            onSelected: (value) {
              setState(() {
                allekurse.remove(value);
                selectedKurse.add(value!);
              });
            },
          ),
          Expanded(
              child: ListView.builder(
                  itemCount: selectedKurse.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(selectedKurse[index]),
                          GestureDetector(
                            child: const Icon(Icons.close_rounded),
                            onTap: () {
                              setState(() {
                                allekurse.add(selectedKurse[index]);
                                selectedKurse.removeAt(index);
                              });
                            },
                          )
                        ],
                      ),
                    );
                  }))
        ]));
  }
}
