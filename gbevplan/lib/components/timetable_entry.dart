import 'package:flutter/material.dart';

class TimeTableEntry extends StatelessWidget {
  // lets make this via an actual object called lesson instead of getting all these informations single handed.
  final String stunde;
  final String raum;
  final String fach;
  final String stfach;
  final bool stfachLineThrough;
  final bool headline;
  final bool highlighted;

  const TimeTableEntry(
      {super.key,
      required this.stunde,
      required this.raum,
      required this.fach,
      required this.stfach,
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
          Text(stunde, style: textstyle),
          Text(raum, style: textstyle),
          Text(fach, style: textstyle),
          Text(stfach,
              style: stfachLineThrough
                  ? textstyle.copyWith(decoration: TextDecoration.lineThrough)
                  : textstyle)
        ],
      ),
    );
  }
}
