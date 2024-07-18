import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gbevplan/components/BottomSheetLesson.dart';
import 'package:gbevplan/components/TimeTableEntry.dart';

class HomeVPlan extends StatefulWidget {
  const HomeVPlan({super.key});

  @override
  State<HomeVPlan> createState() => HomeVPlanState();
}

class HomeVPlanState extends State<HomeVPlan> with TickerProviderStateMixin {
  late AnimationController progress_controller;

  @override
  void initState() {
    // progress_controller = AnimationController(
    //   duration: const Duration(seconds: 2),
    //   vsync: this,
    // )..addListener(() {
    //     setState(() {});
    //   });
    // progress_controller.animateTo(1);
    super.initState();
  }

  @override
  void dispose() {
    progress_controller.dispose();
    super.dispose();
  }

  String currentSelection = "Button 1";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(children: [
        // Padding(
        //   padding: const EdgeInsets.symmetric(vertical: 16),
        //   child: LinearProgressIndicator(
        //     value: progress_controller.value,
        //     borderRadius: BorderRadius.circular(100),
        //   ),
        // ),
        SegmentedButton<String>(
            selectedIcon: const Icon(
              Icons.check,
              size: 0,
            ),
            multiSelectionEnabled: false,
            // Ich kann mit ButtonSegment<T> ein Object in den Buttons abspeichern -> Die Tagespläne
            segments: const <ButtonSegment<String>>[
              ButtonSegment(
                  value: "Button 1",
                  label: Text('Mo'),
                  icon: Icon(
                    Icons.calendar_view_day,
                    size: 0,
                  )),
              ButtonSegment(
                  value: "Button 2",
                  label: Text('Di'),
                  icon: Icon(
                    Icons.calendar_view_day,
                    size: 0,
                  )),
              ButtonSegment(
                  value: "Button 3",
                  label: Text('Mi'),
                  icon: Icon(
                    Icons.calendar_view_day,
                    size: 0,
                  )),
              ButtonSegment(
                  value: "Button 4",
                  label: Text('Do'),
                  icon: Icon(
                    Icons.calendar_view_day,
                    size: 0,
                  )),
              ButtonSegment(
                  value: "Button 5",
                  label: Text('Fr'),
                  icon: Icon(
                    Icons.calendar_view_day,
                    size: 0,
                  )),
            ],
            selected: <String>{currentSelection},
            onSelectionChanged: (Set<String> newSelection) {
              setState(() {
                currentSelection = newSelection.first;
              });
            }),
        const Padding(
          padding: const EdgeInsets.only(top: 16),
          child: TimeTableEntry(
            stunde: "stunde",
            raum: "raum",
            fach: "fach",
            stfach: "st. fach",
            stfachLineThrough: false,
            headline: true,
          ),
        ),
        const Divider(),
        Expanded(
          child: ListView.builder(
              itemCount: 11,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () => {
                        showModalBottomSheet(
                            isScrollControlled:
                                false, // if enabled -> Bottom Sheet becomes full screen sheet
                            scrollControlDisabledMaxHeightRatio: .5,
                            showDragHandle: true,
                            enableDrag: true,
                            context: context,
                            builder: (BuildContext context) {
                              return const BottomSheeetLesson();
                            }).then((value) {
                          setState(() {
                            SystemChrome.setSystemUIOverlayStyle(
                                SystemUiOverlayStyle(
                                    systemNavigationBarColor: Theme.of(context)
                                        .colorScheme
                                        .surfaceContainer));
                          });
                        }),
                        setState(() {
                          SystemChrome.setSystemUIOverlayStyle(
                              SystemUiOverlayStyle(
                                  systemNavigationBarColor: Theme.of(context)
                                      .colorScheme
                                      .surfaceContainerLow));
                        })
                      },
                      child: Card.filled(
                        color: index == 4
                            ? Theme.of(context).colorScheme.surfaceContainerLow
                            : Colors.transparent,
                        child: Padding(
                          padding: index == 4
                              ? const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 16)
                              : const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                          child: TimeTableEntry(
                            stunde: (index + 1).toString(),
                            raum: "006",
                            fach: "Mathe",
                            stfach: "Englisch",
                            highlighted: index == 4 ? true : false,
                          ),
                        ),
                      ),
                    ),
                    index == 11 - 1 || index == 4 - 1 || index == 4
                        ? const Divider(
                            height: 0,
                            color: Colors.transparent,
                          )
                        : const Divider(
                            indent: 20,
                            endIndent: 20,
                          )
                  ],
                );
              }),
        ),
      ]),
    );
  }
}
