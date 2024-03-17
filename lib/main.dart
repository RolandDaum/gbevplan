import 'package:flutter/material.dart';
import 'package:gbevplan/theme/colors.dart';
import 'package:gbevplan/pages/Login.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textSelectionTheme: TextSelectionThemeData(
          selectionColor: AppColor.AccentBlueDark,
          cursorColor: AppColor.Font,
          selectionHandleColor: AppColor.Font,
        ),
      ),

      debugShowCheckedModeBanner: false,
      title: 'GBE - VPlan',
      home: Login(),

    );
  }
}