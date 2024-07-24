import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:gbevplan/Objects/timetable.dart';
import 'package:hive/hive.dart';

class CourseSelection extends StatefulWidget {
  final List<String> selectedKurse;
  final Function(List<String>)? onSelectionChange;

  const CourseSelection(
      {super.key, this.selectedKurse = const [], this.onSelectionChange});

  @override
  State<CourseSelection> createState() => _CourseSelectionState();
}

class _CourseSelectionState extends State<CourseSelection> {
  TextEditingController tecKursSelection = TextEditingController();
  Box appdataBox = Hive.box("appdata");
  int jahrgang = 0;
  List<String> allekurse = [];
  List<String> nonselectedKurse = [];
  List<String> selectedKurse = [];

  @override
  void initState() {
    super.initState();

    jahrgang = appdataBox.get("jahrgang");

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
        calcNonSelectedKurse();
      });
    });
  }

  @override
  void didUpdateWidget(covariant CourseSelection oldWidget) {
    super.didUpdateWidget(oldWidget);

    calcNonSelectedKurse();
  }

  void calcNonSelectedKurse() {
    selectedKurse = [];
    if (widget.selectedKurse.isEmpty) {
      selectedKurse = appdataBox.get("selectedKurse").cast<String>();
    } else {
      selectedKurse.addAll(widget.selectedKurse);
    }
    nonselectedKurse = [];
    nonselectedKurse.addAll(allekurse);
    for (var kurs in selectedKurse) {
      nonselectedKurse.remove(kurs);
    }
    setState(() {
      nonselectedKurse;
    });
  }

  @override
  void dispose() {
    super.dispose();

    print(" D I S P O S I n G  -  COURESE DRPOWOND");

    appdataBox.put("selectedKurse", selectedKurse);
    Timetable.createTimetable();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownMenu(
      dropdownMenuEntries:
          nonselectedKurse.map<DropdownMenuEntry<String>>((String value) {
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
          nonselectedKurse.remove(value);
          selectedKurse.add(value!);
          if (widget.onSelectionChange != null) {
            widget.onSelectionChange!(selectedKurse);
          }
          tecKursSelection.text = "";
        });
      },
    );
  }
}
