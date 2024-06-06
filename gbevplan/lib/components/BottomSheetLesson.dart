import 'package:flutter/material.dart';

class BottomSheeetLesson extends StatelessWidget {
  // final Object fach;
  // const BottomSheeetLesson({super.key, required this.fach});

  // TODO: Later add Lesson Subject Object with all the information
  const BottomSheeetLesson({super.key});

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
                      "Mathe LK 1",
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
                      "Oberstufentrakt 006",
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
                      "Karl Helge Lang",
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
                      "Buch Seite 123 Nr.1,2,3a-c",
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
                      "P L A C E H O L D E R",
                      style: tsOverline,
                    ),
                    Text(
                      "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.",
                      style: tsHeadline,
                    )
                  ],
                ),
              ),
            ),
          ]),
    );
  }
}
