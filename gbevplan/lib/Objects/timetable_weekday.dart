import 'package:gbevplan/Objects/timetable_lesson.dart';
import 'package:hive/hive.dart';

part 'timetable_weekday.g.dart';

@HiveType(typeId: 1)
class TimetableWeekday {
  @HiveField(0)
  List<TimetableLesson> dailytimetable;
  @HiveField(1)
  int dayofweek;
  TimetableWeekday({required this.dailytimetable, required this.dayofweek});
}
