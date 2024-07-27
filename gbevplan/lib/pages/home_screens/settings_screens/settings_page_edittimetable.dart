import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gbevplan/components/course_selection.dart';
import 'package:gbevplan/components/empty_widget.dart';
import 'package:gbevplan/components/jahrgangs_selection.dart';
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
  List<String> selectedKurse = [];
  Box appdataBox = Hive.box("appdata");

  @override
  void initState() {
    super.initState();

    selectedKurse = appdataBox.get("selectedKurse").cast<String>();
    jahrgang = appdataBox.get("jahrgang");
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
              child: Jahrgangsselection(
                selectedJahrgang: jahrgang,
              )),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: CourseSelection(
                selectedKurse: selectedKurse,
                onSelectionChange: (value) {
                  setState(() {
                    selectedKurse = value;
                  });
                },
              )),
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
