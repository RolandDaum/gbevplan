import 'package:flutter/material.dart';

class EmptyWidget extends StatelessWidget implements PreferredSizeWidget {
  const EmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
    );
  }

  @override
  Size get preferredSize => const Size(0.0, 0.0);
}
