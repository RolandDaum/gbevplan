import 'package:flutter/material.dart';
import 'package:gbevplan/Objects/timetable_lesson.dart';

class BottomSheeetLesson extends StatelessWidget {
  final TimetableLesson ttbllesson;
  const BottomSheeetLesson({super.key, required this.ttbllesson});

  @override
  Widget build(BuildContext context) {
    TextStyle tsOverline = Theme.of(context).textTheme.labelMedium!;
    TextStyle tsHeadline = Theme.of(context).textTheme.bodyLarge!;
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(0)),
      child: ListView(
          padding:
              const EdgeInsets.symmetric(horizontal: 4).copyWith(bottom: 4),
          children: [
            Card.filled(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              elevation: 0,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Fach",
                      style: tsOverline,
                    ),
                    Text(
                      ttbllesson.coursename,
                      style: tsHeadline,
                    )
                  ],
                ),
              ),
            ),
            Card.filled(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              elevation: 0,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Raum",
                      style: tsOverline,
                    ),
                    Text(
                      ttbllesson.raum,
                      style: tsHeadline,
                    )
                  ],
                ),
              ),
            ),
            Card.filled(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              elevation: 0,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Lehrer",
                      style: tsOverline,
                    ),
                    Text(
                      "",
                      style: tsHeadline,
                    )
                  ],
                ),
              ),
            ),
            Card.filled(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              elevation: 0,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Aufgaben",
                      style: tsOverline,
                    ),
                    Text(
                      "",
                      style: tsHeadline,
                    )
                  ],
                ),
              ),
            ),
            // Card.filled(
            //   color: Theme.of(context).colorScheme.surfaceContainerHighest,
            //   elevation: 0,
            //   child: Padding(
            //     padding:
            //         const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            //     child: Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         Text(
            //           "P L A C E H O L D E R",
            //           style: tsOverline,
            //         ),
            //         Text(
            //           "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.",
            //           style: tsHeadline,
            //         )
            //       ],
            //     ),
            //   ),
            // ),
          ]),
    );
  }
}
