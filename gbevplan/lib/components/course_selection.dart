import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gbevplan/Objects/timetable.dart';
import 'package:gbevplan/main.dart';
import 'package:hive/hive.dart';

class CourseSelection extends StatefulWidget {
  final List<String> selectedKurse;
  final Function(List<String>)? onSelectionChange;
  final bool createTimeTableOnDispose;

  const CourseSelection(
      {super.key,
      this.selectedKurse = const [],
      this.onSelectionChange,
      this.createTimeTableOnDispose = true});

  @override
  State<CourseSelection> createState() => _CourseSelectionState();
}

class _CourseSelectionState extends State<CourseSelection>
    with WidgetsBindingObserver {
  TextEditingController tecKursSelection = TextEditingController();
  Box appdataBox = Hive.box("appdata");
  int jahrgang = 0;
  List<String> allekurse = [];
  List<String> nonselectedKurse = [];
  List<String> selectedKurse = [];
  FocusNode dropdownFocusNode = FocusNode();
  double bottomInsetD1 = -1;
  double bottomInsetD2 = -1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    jahrgang = appdataBox.get("jahrgang");
    if (!(jahrgang >= 5)) {
      Fluttertoast.showToast(
        msg: "kein Jahrgang ausgewählt",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor:
            Theme.of(navigatorKey.currentContext!).colorScheme.errorContainer,
        textColor:
            Theme.of(navigatorKey.currentContext!).colorScheme.onErrorContainer,
      );
    } else {
      FirebaseDatabase.instance
          .ref('/data/ttbyear')
          .once()
          .then((DatabaseEvent event) {
        final db = FirebaseFirestore.instance;
        db.databaseId = "database";
        print(jahrgang);
        print(event.snapshot.value as String);
        db
            .collection(event.snapshot.value as String)
            .doc(jahrgang.toString())
            .get()
            .then((value) {
          print(value.data()!["all_courses"].toString());
          allekurse = value.data()!["all_courses"].cast<String>();

          calcNonSelectedKurse();
        });
      });
    }
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();

    // Detects the bottom inset delta value to determine if the keyboard is either opening (+ delta) or closing (- delta) in order to unfocus the DropdownMenu so it properly disposes
    final bottomInset = View.of(context).viewInsets.bottom;

    if (bottomInsetD1 == -1) {
      bottomInsetD1 = bottomInset;
    } else {
      bottomInsetD2 = bottomInset;
      double deltaBottomInset = bottomInsetD2 - bottomInsetD1;
      if (deltaBottomInset < 0) {
        dropdownFocusNode.unfocus();
      }
      bottomInsetD1 = bottomInsetD2;
      bottomInsetD2 = -1;
    }
  }

  @override
  void didUpdateWidget(covariant CourseSelection oldWidget) {
    super.didUpdateWidget(oldWidget);
    calcNonSelectedKurse();
  }

  void calcNonSelectedKurse() {
    selectedKurse = [];
    if (widget.selectedKurse.isEmpty) {
      selectedKurse.addAll(appdataBox.get("selectedKurse").cast<String>());
    } else {
      selectedKurse.addAll(widget.selectedKurse);
    }
    nonselectedKurse = [];
    nonselectedKurse.addAll(allekurse);
    for (var kurs in selectedKurse) {
      setState(() {
        nonselectedKurse.remove(kurs);
      });
    }
    appdataBox.put("selectedKurse", selectedKurse);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);

    tecKursSelection.dispose();

    appdataBox.put("selectedKurse", selectedKurse);
    if (widget.createTimeTableOnDispose) {
      Timetable.createTimetable();
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownMenu(
      focusNode: dropdownFocusNode,
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
          if (value == null) {
            return;
          }
          nonselectedKurse.remove(value);
          selectedKurse.add(value);
          if (widget.onSelectionChange != null) {
            widget.onSelectionChange!(selectedKurse);
          }
          tecKursSelection.text = "";
        });
      },
    );
  }
}
