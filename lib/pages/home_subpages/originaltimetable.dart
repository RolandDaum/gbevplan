import 'package:flutter/material.dart';
import 'package:gbevplan/theme/colors.dart';
import 'package:hive_flutter/adapters.dart';

class OrgTimeTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.backgroundDark
      ),
      child: Center(
        child: Text('ORG T I M E  T A B L E'),
      ),
    );
  }
}