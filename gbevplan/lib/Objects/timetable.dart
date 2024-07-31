import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gbevplan/Objects/timetable_lesson.dart';
import 'package:gbevplan/Objects/timetable_weekday.dart';
import 'package:gbevplan/main.dart';
import 'package:hive/hive.dart';

part 'timetable.g.dart';

@HiveType(typeId: 0)
class Timetable {
  @HiveField(0)
  final List<TimetableWeekday> timetable;

  Timetable({required this.timetable});

  /// Creates a new timetable based on the user selected courses and the in the firestore saved global timetable
  static Future<void> createTimetable() async {
    Box appdataBox = Hive.box("appdata");
    int jahrgang = appdataBox.get("jahrgang");
    List<String> selectedCourses =
        appdataBox.get("selectedKurse").cast<String>();
    String ttbyear = "";
    await FirebaseDatabase.instance
        .ref('/data/ttbyear')
        .once()
        .then((DatabaseEvent event) {
      ttbyear = event.snapshot.value as String;
    });

    List<TimetableWeekday> timetable = [];

    final db = FirebaseFirestore.instance;
    db.databaseId = "database";

    for (int d = 0; d < 5; d++) {
      List<TimetableLesson> dailytimetable = [];
      for (int h = 0; h < 11; h++) {
        Map<String, dynamic>? allcoursesinlesson;
        await db
            .collection(ttbyear)
            .doc(jahrgang.toString())
            .collection(d.toString())
            .doc(h.toString())
            .get()
            .then((value) {
          allcoursesinlesson = value.data();
        });
        bool addedcourse = false;
        for (var course in selectedCourses) {
          if (allcoursesinlesson!.containsKey(course)) {
            dailytimetable.add(TimetableLesson(
                coursename: course,
                raum: allcoursesinlesson![course]["raum"],
                stunde: (h + 1).toString()));
            addedcourse = true;
            break;
          }
        }
        !addedcourse
            ? dailytimetable.add(TimetableLesson(
                coursename: "---",
                raum: "---",
                stunde: (h + 1).toString(),
                emptyEntry: true))
            : {};
      }
      timetable
          .add(TimetableWeekday(dailytimetable: dailytimetable, dayofweek: d));
    }
    Timetable ttmbl = Timetable(timetable: timetable);
    ttmbl.cleanUpTimeTable();
    await appdataBox.put("timetable", ttmbl).then((value) {
      Fluttertoast.showToast(
        msg: "created timetable",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor:
            Theme.of(navigatorKey.currentContext!).colorScheme.primaryContainer,
        textColor: Theme.of(navigatorKey.currentContext!)
            .colorScheme
            .onPrimaryContainer,
      );
      return;
    });
  }

  /// Removes all emptyEntry's from the end of each TimetableWeekday
  void cleanUpTimeTable() {
    for (var weekdayTTBL in timetable) {
      for (int i = weekdayTTBL.dailytimetable.length - 1; i >= 0; i--) {
        if (weekdayTTBL.dailytimetable[i].emptyEntry) {
          weekdayTTBL.dailytimetable.removeAt(i);
        } else {
          break;
        }
      }
    }
  }
}
