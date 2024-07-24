import 'package:flutter/material.dart';
import 'package:gbevplan/components/course_selection.dart';
import 'package:gbevplan/components/empty_widget.dart';
import 'package:hive/hive.dart';

class SetupPageCourseselection extends StatefulWidget {
  const SetupPageCourseselection({super.key});

  @override
  State<SetupPageCourseselection> createState() =>
      _SetupPageCourseselectionState();
}

class _SetupPageCourseselectionState extends State<SetupPageCourseselection> {
  List<String> selectedKurse = [];
  Box appdataBox = Hive.box("appdata");

  @override
  void initState() {
    super.initState();

    print(appdataBox.get("selectedKurse"));
    print(appdataBox.get("selectedKurse") == null);

    selectedKurse = appdataBox.get("selectedKurse").cast<String>();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CourseSelection(
          selectedKurse: selectedKurse,
          onSelectionChange: ((value) {
            setState(() {
              selectedKurse = value;
            });
          }),
        ),
        Expanded(
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
                          selectedKurse.removeAt(index);

                          setState(() {
                            selectedKurse;
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
      ],
    );
  }
}
