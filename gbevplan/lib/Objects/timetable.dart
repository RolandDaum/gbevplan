import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:gbevplan/Objects/timetable_lesson.dart';
import 'package:gbevplan/Objects/timetable_weekday.dart';
import 'package:hive/hive.dart';

part 'timetable.g.dart';

@HiveType(typeId: 0)
class Timetable {
  @HiveField(0)
  final List<TimetableWeekday> timetable;

  Timetable({required this.timetable});

  static createTimetable() async {
    Box appdataBox = Hive.box("appdata");
    int jahrgang = appdataBox.get("jahrgang");
    List<String> selectedCourses = appdataBox.get("selectedKurse");
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
            dailytimetable.add(TimetableLesson(coursename: course, raum: ""));
            addedcourse = true;
            break;
          }
        }
        !addedcourse
            ? dailytimetable.add(TimetableLesson(coursename: "", raum: ""))
            : {};
      }
      timetable
          .add(TimetableWeekday(dailytimetable: dailytimetable, dayofweek: d));
    }

    await appdataBox.put("timetable", Timetable(timetable: timetable));
    print(" S A V E D  -  T I M E T A B L E");
  }
}
