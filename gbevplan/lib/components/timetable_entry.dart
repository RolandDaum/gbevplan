import 'package:flutter/material.dart';
import 'package:gbevplan/Objects/timetable_lesson.dart';

class TimeTableEntry extends StatelessWidget {
  // lets make this via an actual object called lesson instead of getting all these informations single handed.
  final TimetableLesson timeTableLesson;
  final bool stfachLineThrough;
  final bool headline;
  final bool highlighted;

  const TimeTableEntry(
      {super.key,
      required this.timeTableLesson,
      this.stfachLineThrough = true,
      this.headline = false,
      this.highlighted = false});

  void selectTextStyle(BuildContext context, TextStyle textstyle) {}

  @override
  Widget build(BuildContext context) {
    TextStyle textstyle = Theme.of(context).textTheme.bodyLarge!;
    if (headline) {
      textstyle = Theme.of(context).textTheme.labelLarge!;
    }
    if (highlighted) {
      textstyle = Theme.of(context)
          .textTheme
          .bodyLarge!
          .copyWith(fontWeight: FontWeight.bold);
    }

    return Container(
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(timeTableLesson.stunde, style: textstyle),
          Text(timeTableLesson.raum, style: textstyle),
          Text(timeTableLesson.coursename, style: textstyle),
          Text(timeTableLesson.replacedFach,
              style: stfachLineThrough
                  ? textstyle.copyWith(decoration: TextDecoration.lineThrough)
                  : textstyle)
        ],
      ),
    );
  }
}
