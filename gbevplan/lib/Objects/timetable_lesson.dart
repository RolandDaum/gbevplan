import 'package:hive/hive.dart';

part 'timetable_lesson.g.dart';

@HiveType(typeId: 2)
class TimetableLesson {
  @HiveField(0)
  String coursename;
  @HiveField(1)
  String raum;
  @HiveField(2)
  String stunde;
  @HiveField(3)
  String replacedFach;
  @HiveField(4)
  bool emptyEntry;
  TimetableLesson(
      {required this.coursename,
      required this.raum,
      required this.stunde,
      this.replacedFach = "",
      this.emptyEntry = false});

  String crnToTitle() {
    // TODO: Converter from coursname to proper Title
    return "";
  }
}
