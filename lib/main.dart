import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gbevplan/code/normTTCalc.dart';
import 'package:gbevplan/router.dart';
import 'package:gbevplan/theme/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
  await Hive.initFlutter();
  Box userdata_box = await Hive.openBox('userdata');
  Box appdata_box = await Hive.openBox('appdata');
  Box apidata_box = await Hive.openBox('apidata');

  // appdata_box.deleteFromDisk();
  // apidata_box.deleteFromDisk();
  // userdata_box.deleteFromDisk();
  if (appdata_box.isEmpty || userdata_box.isEmpty) {  initData();  }
  else if (appdata_box.get('data_version') != '1.0.0') {  updataData();  }

  runApp(const MyApp());
}

// init Data on first startup
void initData() {
  print('I N I T  -  H I V E');
  Box userdata_box = Hive.box('userdata');
  Box appdata_box = Hive.box('appdata');
  Box apidata_box = Hive.box('apidata');
  List<String> selectedCourseList = [];
  userdata_box.put('selected_courses', selectedCourseList);
  userdata_box.put('jahrgang', '');
  Map<String, String> securedata = {
    'username': '',
    'password': '',
  };
  userdata_box.put('securedata', securedata);

  appdata_box.put('data_version', '1.0.0');
  appdata_box.put('rememberme', false);

  // 'normtimetable'
  calcNormTT();
}
void updataData() {
  print('U P D A T E  -  H I V E');
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: AppColor.transparent,
        systemNavigationBarColor: AppColor.transparent,
        systemStatusBarContrastEnforced: false,
        statusBarIconBrightness: Brightness.light
      )
    );
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge, overlays: [SystemUiOverlay.bottom]);
    return MaterialApp.router(
      theme: ThemeData(
        textSelectionTheme: TextSelectionThemeData(
          selectionColor: AppColor.AccentBlueDark,
          cursorColor: AppColor.Font,
          selectionHandleColor: AppColor.Font,
        ),
        fontFamily: GoogleFonts.albertSans().fontFamily,
        textTheme: GoogleFonts.albertSansTextTheme(),
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle.light
        )
      ),

      debugShowCheckedModeBanner: false,
      routerConfig: router,
      title: 'GBE - VPlan',
      // home: Login(),
    );
  }
}