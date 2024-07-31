import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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

  PageController pgcWeekdayScroll = PageController();

  int _subjSelecIndex = -1;
  int currentWDSelection = 0;
  int currentWD = 0;

  late Timetable timetable;

  @override
  void initState() {
    super.initState();
    timetable = appdataBox.get("timetable");

    setCurrentTime();
  }

  void setCurrentTime() {
    DateTime currentDT = DateTime.now();
    int currentWeekday = currentDT.weekday - 1;

    currentWDSelection = currentWeekday > 4 ? 0 : currentWeekday;
    _subjSelecIndex = -1;
    currentWD = currentWDSelection;

    if (currentWeekday > 4) return;

    List<TimeOfDay> subjectTimes = [
      TimeOfDay(hour: 7, minute: 40),
      TimeOfDay(hour: 8, minute: 30),
      TimeOfDay(hour: 9, minute: 35),
      TimeOfDay(hour: 10, minute: 25),
      TimeOfDay(hour: 11, minute: 25),
      TimeOfDay(hour: 12, minute: 15),
      TimeOfDay(hour: 13, minute: 5),
      TimeOfDay(hour: 13, minute: 50),
      TimeOfDay(hour: 14, minute: 35),
      TimeOfDay(hour: 15, minute: 25),
      TimeOfDay(hour: 16, minute: 10),
      TimeOfDay(hour: 16, minute: 55),
    ];

    for (int i = 0; i < subjectTimes.length; i++) {
      DateTime subjectTime = DateTime(
        currentDT.year,
        currentDT.month,
        currentDT.day,
        subjectTimes[i].hour,
        subjectTimes[i].minute,
      );

      if (currentDT.isAfter(subjectTime)) {
        _subjSelecIndex++;
      } else {
        break;
      }
    }

    if (currentDT.isAfter(
      DateTime(
        currentDT.year,
        currentDT.month,
        currentDT.day,
        subjectTimes.last.hour,
        subjectTimes.last.minute,
      ),
    )) {
      _subjSelecIndex = -1;
      currentWDSelection = (currentWeekday + 1) > 4 ? 0 : currentWeekday + 1;
    }

    if (pgcWeekdayScroll.hasClients) {
      pgcWeekdayScroll.animateToPage(
        currentWDSelection,
        duration: Durations.medium1,
        curve: Curves.easeInOutQuad,
      );
    } else {
      pgcWeekdayScroll = PageController(initialPage: currentWDSelection);
    }

    setState(() {
      currentWDSelection;
      _subjSelecIndex;
      currentWD;
    });
  }

  void openLessonBottomSheet(TimetableLesson ttbllesson) {
    !ttbllesson.emptyEntry
        ? showModalBottomSheet(
            isScrollControlled:
                false, // if enabled -> Bottom Sheet becomes full screen sheet
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
    return Padding(
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
                pgcWeekdayScroll.animateToPage(currentWDSelection,
                    duration: Durations.medium1, curve: Curves.easeInOutQuad);
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
        Expanded(
            child: PageView.builder(
          controller: pgcWeekdayScroll,
          onPageChanged: (value) {
            setState(() {
              currentWDSelection = value;
            });
          },
          itemCount: timetable.timetable.length,
          itemBuilder: (context, indexWD) {
            return RefreshIndicator(
              onRefresh: () async {
                setState(() {
                  timetable = appdataBox.get("timetable");
                });
                setCurrentTime();
              },
              child: ListView.builder(
                  itemCount: timetable.timetable[indexWD].dailytimetable.length,
                  itemBuilder: (BuildContext context, int index) {
                    bool activecard = false;
                    bool lastEntry = false;

                    if (index == _subjSelecIndex && indexWD == currentWD) {
                      activecard = true;
                    }
                    if (index == _subjSelecIndex - 1) {
                      lastEntry = true;
                    }

                    return Column(
                      children: [
                        GestureDetector(
                          onTap: () => {
                            if (index == _subjSelecIndex)
                              {
                                openLessonBottomSheet(timetable
                                    .timetable[indexWD].dailytimetable[index])
                              }
                          },
                          onDoubleTap: () {
                            openLessonBottomSheet(timetable
                                .timetable[indexWD].dailytimetable[index]);
                          },
                          child: Card.filled(
                            color: activecard
                                ? Theme.of(context)
                                    .colorScheme
                                    .secondaryContainer // Highlighted Lesson
                                : Colors.transparent,
                            child: Padding(
                              padding: activecard
                                  ? const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 16)
                                  : const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                              child: TimeTableEntry(
                                timeTableLesson: timetable
                                    .timetable[indexWD].dailytimetable[index],
                                highlighted: activecard ? true : false,
                              ),
                            ),
                          ),
                        ),
                        lastEntry || activecard
                            ? const Divider()
                            : index ==
                                    timetable.timetable[indexWD].dailytimetable
                                            .length -
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
            );
          },
        ))
      ]),
      // ),
    );
  }
}
