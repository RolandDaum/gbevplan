import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:gbevplan/pages/home.dart';
import 'package:gbevplan/pages/login.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MainGBEVplan());
}

class MainGBEVplan extends StatefulWidget {
  const MainGBEVplan({super.key});

  @override
  State<MainGBEVplan> createState() => Main_GBEVplanState();
}

// ignore: camel_case_types
class Main_GBEVplanState extends State<MainGBEVplan> {
  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
        builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
      return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
            useMaterial3: true,
            colorScheme: lightDynamic,
            fontFamily: GoogleFonts.mPlusRounded1c().fontFamily),
        darkTheme: ThemeData(
            colorScheme: darkDynamic,
            useMaterial3: true,
            fontFamily: GoogleFonts.mPlusRounded1c().fontFamily),
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => const page_login(),
          '/home': (context) => const page_home()
        },
      );
    });
  }
}
