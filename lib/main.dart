import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gbevplan/objectbox/userdata.dart';
import 'package:gbevplan/objectbox/objectbox.dart';
import 'package:gbevplan/router.dart';
import 'package:gbevplan/theme/colors.dart';
import 'package:google_fonts/google_fonts.dart';

late ObjectBox objectbox;
Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  objectbox = await ObjectBox.create();

  runApp(const MyApp());
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