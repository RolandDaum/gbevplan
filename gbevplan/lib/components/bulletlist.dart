import 'package:flutter/material.dart';

class Bulletlist extends StatelessWidget {
  final List<Bulletpoint> data;
  final String bulletpointChar;
  final TextStyle? textstyle;
  final EdgeInsetsGeometry padding;

  const Bulletlist(
      {super.key,
      required this.data,
      this.bulletpointChar = "•",
      this.textstyle,
      this.padding = const EdgeInsets.all(0)});

  @override
  Widget build(BuildContext context) {
    final effectiveTextStyle =
        textstyle ?? Theme.of(context).textTheme.bodyLarge;

    return Expanded(
      child: Padding(
        padding: padding,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: data.length,
          // physics: const NeverScrollableScrollPhysics(), // Disable scrolling
          itemBuilder: (context, index) {
            final indentLevel = data[index].indent;
            final paddingSize = _getPaddingSize(indentLevel);

            return Padding(
              padding: EdgeInsets.only(left: paddingSize)
                  .add(const EdgeInsets.symmetric(vertical: 8)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Text(
                      bulletpointChar,
                      style: effectiveTextStyle?.copyWith(
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Flexible(
                    child: Text(
                      data[index].text,
                      style: effectiveTextStyle,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  double _getPaddingSize(int indentLevel) {
    switch (indentLevel) {
      case 0:
        return 0;
      case 1:
        return 24;
      case 2:
        return 42;
      default:
        return 54;
    }
  }
}

class Bulletpoint {
  final int indent;
  final String text;

  const Bulletpoint({this.indent = 0, required this.text});
}
