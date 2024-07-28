import 'package:flutter/material.dart';
import 'package:gbevplan/Objects/timetable.dart';
import 'package:gbevplan/Objects/timetable_lesson.dart';
import 'package:gbevplan/components/bottomsheet_lesson.dart';
import 'package:gbevplan/components/timetable_entry.dart';
import 'package:hive/hive.dart';

class HomePageVplan extends StatefulWidget {
  const HomePageVplan({super.key});

  @override
  State<HomePageVplan> createState() => _HomePageVplanState();
}

class _HomePageVplanState extends State<HomePageVplan>
    with TickerProviderStateMixin {
  Box appdataBox = Hive.box("appdata");

  int _subjSelecIndex = -1;
  int currentWDSelection = 0;

  late Timetable timetable;

  @override
  void initState() {
    super.initState();

    timetable = appdataBox.get("timetable");

    setCurrentTime();
  }

  void setCurrentTime() {
    int currentWeekday = DateTime.now().weekday.toInt() - 1;
    currentWDSelection = currentWeekday > 4 ? 0 : currentWeekday;

    DateTime currentDT = DateTime.now();
    if (currentWeekday > 4) {
      _subjSelecIndex = -1;
      return;
    }
    if (currentDT.isAfter(
        DateTime(currentDT.year, currentDT.month, currentDT.day, 7, 40))) {
      _subjSelecIndex++;
    }
    if (currentDT.isAfter(
        DateTime(currentDT.year, currentDT.month, currentDT.day, 8, 30))) {
      _subjSelecIndex++;
    }
    if (currentDT.isAfter(
        DateTime(currentDT.year, currentDT.month, currentDT.day, 9, 35))) {
      _subjSelecIndex++;
    }
    if (currentDT.isAfter(
        DateTime(currentDT.year, currentDT.month, currentDT.day, 10, 25))) {
      _subjSelecIndex++;
    }
    if (currentDT.isAfter(
        DateTime(currentDT.year, currentDT.month, currentDT.day, 11, 25))) {
      _subjSelecIndex++;
    }
    if (currentDT.isAfter(
        DateTime(currentDT.year, currentDT.month, currentDT.day, 12, 15))) {
      _subjSelecIndex++;
    }
    if (currentDT.isAfter(
        DateTime(currentDT.year, currentDT.month, currentDT.day, 13, 5))) {
      _subjSelecIndex++;
    }
    if (currentDT.isAfter(
        DateTime(currentDT.year, currentDT.month, currentDT.day, 13, 50))) {
      _subjSelecIndex++;
    }
    if (currentDT.isAfter(
        DateTime(currentDT.year, currentDT.month, currentDT.day, 14, 35))) {
      _subjSelecIndex++;
    }
    if (currentDT.isAfter(
        DateTime(currentDT.year, currentDT.month, currentDT.day, 15, 25))) {
      _subjSelecIndex++;
    }
    if (currentDT.isAfter(
        DateTime(currentDT.year, currentDT.month, currentDT.day, 16, 10))) {
      _subjSelecIndex++;
    }
    if (currentDT.isAfter(
        DateTime(currentDT.year, currentDT.month, currentDT.day, 16, 55))) {
      _subjSelecIndex = -1;
    }

    setState(() {
      currentWDSelection;
      _subjSelecIndex;
    });
  }

  void openLessonBottomSheet(TimetableLesson ttbllesson) {
    !ttbllesson.emptyEntry
        ? showModalBottomSheet(
            isScrollControlled:
                false, // if enabled -> Bottom Sheet becomes full screen sheet
            scrollControlDisabledMaxHeightRatio: .5,
            showDragHandle: true,
            enableDrag: true,
            context: context,
            builder: (BuildContext context) {
              return BottomSheeetLesson(
                ttbllesson: ttbllesson,
              );
            }).then((value) {})
        : {};
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        setCurrentTime();
        setState(() {
          timetable = appdataBox.get("timetable");
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: SegmentedButton<int>(
                selectedIcon: const Icon(
                  Icons.check,
                  size: 0,
                ),
                multiSelectionEnabled: false,
                // Man kann mit ButtonSegment<T> ein Object in den Buttons abspeichern -> Die Tagespläne
                segments: const <ButtonSegment<int>>[
                  ButtonSegment(
                      value: 0,
                      label: Text('Mo'),
                      icon: Icon(
                        Icons.calendar_view_day,
                        size: 0,
                      )),
                  ButtonSegment(
                      value: 1,
                      label: Text('Di'),
                      icon: Icon(
                        Icons.calendar_view_day,
                        size: 0,
                      )),
                  ButtonSegment(
                      value: 2,
                      label: Text('Mi'),
                      icon: Icon(
                        Icons.calendar_view_day,
                        size: 0,
                      )),
                  ButtonSegment(
                      value: 3,
                      label: Text('Do'),
                      icon: Icon(
                        Icons.calendar_view_day,
                        size: 0,
                      )),
                  ButtonSegment(
                      value: 4,
                      label: Text('Fr'),
                      icon: Icon(
                        Icons.calendar_view_day,
                        size: 0,
                      )),
                ],
                selected: <int>{currentWDSelection},
                onSelectionChanged: (newSelection) {
                  setState(() {
                    currentWDSelection = newSelection.first;
                  });
                }),
          ),
          TimeTableEntry(
            timeTableLesson: TimetableLesson(
                coursename: "fach",
                raum: "raum",
                stunde: "stunde",
                replacedFach: "st. fach"),
            stfachLineThrough: false,
            headline: true,
          ),
          const Divider(),
          // TODO: Make the timetable horizontal scrollable
          Expanded(
            child: ListView.builder(
                itemCount: timetable
                    .timetable[currentWDSelection].dailytimetable.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () => {
                          if (index == _subjSelecIndex)
                            {
                              openLessonBottomSheet(timetable
                                  .timetable[currentWDSelection]
                                  .dailytimetable[index])
                            }
                        },
                        onDoubleTap: () {
                          openLessonBottomSheet(timetable
                              .timetable[currentWDSelection]
                              .dailytimetable[index]);
                        },
                        child: Card.filled(
                          color: index == _subjSelecIndex
                              ? Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer // Highlighted Lesson
                              : Colors.transparent,
                          child: Padding(
                            padding: index == _subjSelecIndex
                                ? const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 16)
                                : const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                            child: TimeTableEntry(
                              timeTableLesson: timetable
                                  .timetable[currentWDSelection]
                                  .dailytimetable[index],
                              highlighted:
                                  index == _subjSelecIndex ? true : false,
                            ),
                          ),
                        ),
                      ),
                      index == _subjSelecIndex - 1 || index == _subjSelecIndex
                          ? const Divider()
                          : index ==
                                  timetable.timetable[currentWDSelection]
                                          .dailytimetable.length -
                                      1
                              ? const Divider(
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
      ),
    );
  }
}
