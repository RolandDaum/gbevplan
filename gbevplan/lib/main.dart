import 'package:cloud_functions/cloud_functions.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarIconBrightness:
          WidgetsBinding.instance.platformDispatcher.platformBrightness ==
                  Brightness.light
              ? Brightness.dark
              : Brightness.light,
    ),
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
  void initState() {
    super.initState();
    _callFunction();
  }

  void _callFunction() async {
    int timestamp = 0;
    await FirebaseDatabase.instance
        .ref("/URL/0/timestamp")
        .once()
        .then((value) => {
              value.snapshot.value != null
                  ? timestamp = value.snapshot.value as int
                  : ()
            })
        .onError((e, s) => {});
    if (!(timestamp <=
        DateTime.now().millisecondsSinceEpoch - (5 * 60 * 1000))) {
      return;
    }
    await FirebaseFunctions.instanceFor(region: 'us-central1')
        .httpsCallable('UUIDFunctionOnCall')
        .call()
        .then((value) => {print("C A L L E D")})
        .onError((e, s) => {print(e)});
  }

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
            // colorScheme: ColorScheme.highContrastLight(),
            colorSchemeSeed: lightDynamic != null
                ? lightDynamic.primary
                : const Color(0xFF002A68)),
        darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            fontFamily: GoogleFonts.mPlusRounded1c().fontFamily,
            // colorScheme: const ColorScheme.highContrastDark(),
            colorSchemeSeed: darkDynamic != null
                ? darkDynamic.primary
                : const Color(0xFF002A68)),
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
