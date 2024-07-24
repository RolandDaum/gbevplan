import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class Jahrgangsselection extends StatefulWidget {
  final int selectedJahrgang;
  const Jahrgangsselection({super.key, this.selectedJahrgang = 0});

  @override
  State<Jahrgangsselection> createState() => _JahrgangsselectionState();
}

class _JahrgangsselectionState extends State<Jahrgangsselection> {
  TextEditingController tecJahrgangSelection = TextEditingController();
  Box appdataBox = Hive.box("appdata");
  @override
  Widget build(BuildContext context) {
    return DropdownMenu(
      dropdownMenuEntries: const [
        DropdownMenuEntry<int>(value: 5, label: "Jahrgang 5", enabled: false),
        DropdownMenuEntry<int>(value: 6, label: "Jahrgang 6", enabled: false),
        DropdownMenuEntry<int>(value: 7, label: "Jahrgang 7", enabled: false),
        DropdownMenuEntry<int>(value: 8, label: "Jahrgang 8", enabled: false),
        DropdownMenuEntry<int>(value: 9, label: "Jahrgang 9", enabled: false),
        DropdownMenuEntry<int>(value: 10, label: "Jahrgang 10", enabled: false),
        DropdownMenuEntry<int>(value: 11, label: "Jahrgang 11", enabled: false),
        DropdownMenuEntry<int>(value: 12, label: "Jahrgang 12", enabled: true),
        DropdownMenuEntry<int>(value: 13, label: "Jahrgang 13", enabled: false),
      ],
      width: 250,
      menuHeight: 200,
      controller: tecJahrgangSelection,
      label: const Text("Jahrgang"),
      enableSearch: false,
      initialSelection: widget.selectedJahrgang,
      enableFilter: false,
      requestFocusOnTap: false,
      onSelected: (value) {
        print(" s a v i n g  -  j a h r g a n g ");
        appdataBox.put("jahrgang", value);
      },
    );
  }
}
