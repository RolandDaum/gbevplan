import 'package:flutter/material.dart';
import 'package:gbevplan/theme/colors.dart';
import 'package:hive_flutter/adapters.dart';

class News extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('N E W S', style: TextStyle(color: AppColor.Font),),
      ),
    );
  }
}