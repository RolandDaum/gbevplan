import 'package:flutter/material.dart';

class Bulletlist extends StatelessWidget {
  final List<Bulletpoint> data;
  final String bulletpointChar;

  const Bulletlist({super.key, required this.data, this.bulletpointChar = "•"});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: data.length,
        physics:
            const NeverScrollableScrollPhysics(), // TODO: Might have to comment it out for realy long list ?!
        itemBuilder: (context, index) {
          late double _paddingSize;
          int indentlevel = data.elementAt(index).indent;
          switch (indentlevel) {
            case 0:
              _paddingSize = 0;
              break;
            case 1:
              _paddingSize = 24;
              break;
            case 2:
              _paddingSize = 42;
              break;

            default:
              _paddingSize = 54;
              break;
          }

          return Padding(
            padding: EdgeInsets.only(left: _paddingSize)
                .add(const EdgeInsets.symmetric(vertical: 8)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Text(bulletpointChar,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontWeight: FontWeight.bold)),
                ),
                Flexible(
                  child: Text(
                    style: Theme.of(context).textTheme.bodyLarge,
                    data.elementAt(index).text,
                  ),
                )
              ],
            ),
          );
        });
  }
}

class Bulletpoint {
  final int indent;
  final String text;

  Bulletpoint({required this.indent, required this.text});
}