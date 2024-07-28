import 'package:flutter/material.dart';
import 'package:gbevplan/components/course_selection.dart';
import 'package:gbevplan/components/empty_widget.dart';
import 'package:hive/hive.dart';
import 'package:lottie/lottie.dart';

class SetupPageCourseselection extends StatefulWidget {
  const SetupPageCourseselection({super.key});

  @override
  State<SetupPageCourseselection> createState() =>
      _SetupPageCourseselectionState();
}

class _SetupPageCourseselectionState extends State<SetupPageCourseselection>
    with WidgetsBindingObserver {
  List<String> selectedKurse = [];
  Box appdataBox = Hive.box("appdata");
  bool isKeyboardVisible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    selectedKurse = appdataBox.get("selectedKurse").cast<String>();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    final bottomInset = WidgetsBinding.instance.window.viewInsets.bottom;
    setState(() {
      isKeyboardVisible = bottomInset > 0.0;
    });
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (!isKeyboardVisible)
          Container(
            margin: const EdgeInsets.only(top: 54),
            width: 135,
            height: 135,
            child: Lottie.asset(
                "assets/lottie/animation_listgrid_scrollthrough.json",
                delegates: LottieDelegates(
                  values: [
                    // keyPath order: ['layer name', 'group name', 'shape name']
                    ValueDelegate.color(const ["**"],
                        value: Theme.of(context).colorScheme.onSurfaceVariant),
                  ],
                ),
                fit: BoxFit.fill),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 44),
          child: Text(
            "Kurse",
            style: Theme.of(context).textTheme.displayMedium,
          ),
        ),
        CourseSelection(
          selectedKurse: selectedKurse,
          onSelectionChange: ((value) {
            setState(() {
              selectedKurse = value;
            });
          }),
          createTimeTableOnDispose: false,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 34, vertical: 16),
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
              },
            ),
          ),
        ),
      ],
    );
  }
}
