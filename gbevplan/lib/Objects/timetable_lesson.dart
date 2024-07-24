import 'package:hive/hive.dart';

part 'timetable_lesson.g.dart';

@HiveType(typeId: 2)
class TimetableLesson {
  @HiveField(0)
  String coursename;
  @HiveField(1)
  String raum;
  TimetableLesson({required this.coursename, required this.raum});
}
