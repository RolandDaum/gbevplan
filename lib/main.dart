import 'package:flutter/material.dart';
import 'package:gbevplan/theme/colors.dart';
import 'package:gbevplan/pages/Login.dart';
import 'package:google_fonts/google_fonts.dart';

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
        fontFamily: GoogleFonts.albertSans().fontFamily,
        textTheme: GoogleFonts.albertSansTextTheme(),
      ),

      debugShowCheckedModeBanner: false,
      title: 'GBE - VPlan',
      home: const Login(),
    );
  }
}