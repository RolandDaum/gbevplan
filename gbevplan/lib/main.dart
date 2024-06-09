import 'package:dynamic_color/dynamic_color.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gbevplan/firebase_options.dart';
import 'package:gbevplan/pages/Home.dart';
import 'package:gbevplan/pages/home_screens/HomeNews.dart';
import 'package:gbevplan/pages/home_screens/HomeOGTimeTable.dart';
import 'package:gbevplan/pages/home_screens/HomeSettings.dart';
import 'package:gbevplan/pages/login.dart';
import 'package:google_fonts/google_fonts.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
            brightness: Brightness.light,
            fontFamily: GoogleFonts.mPlusRounded1c().fontFamily,
            colorSchemeSeed:
                lightDynamic != null ? lightDynamic.primary : Colors.blue[900]),
        darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            fontFamily: GoogleFonts.mPlusRounded1c().fontFamily,
            colorSchemeSeed:
                darkDynamic != null ? darkDynamic.primary : Colors.blue[900]),
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        // debugShowMaterialGrid: true,
        initialRoute: '/',
        routes: {
          '/': (context) => const page_login(),
          '/home': (context) => const Home(),
          '/home/settings': (context) => const HomeSettings(),
          '/home/news': (context) => const HomeNews(),
          '/home/ogtt': (context) => const HomeOGTimeTable()
        },
      );
    });
  }
}
