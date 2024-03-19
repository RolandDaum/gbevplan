import 'package:flutter/material.dart';
import 'package:gbevplan/dataobj/hive_metadata.dart';
import 'package:gbevplan/theme/colors.dart';
import 'package:gbevplan/pages/Login.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(HIVE_MetaDataAdapter());
  Box<dynamic> data = await Hive.openBox('data');
  if (data.isEmpty) {
    await initMetadata(data);
  }
  runApp(const MyApp());
}
initMetadata(Box<dynamic> data) async {
  HIVE_Metadata hive_metadata = HIVE_Metadata(
    HIVE_UserData('', 0), 
    HIVE_AppData(
      HIVE_AppInfo('1.0.0', 'GBE-VPlan'), 
      HIVE_UIInfo(false), 
      HIVE_APIInfo('', 'domain.com', ''), 
      HIVE_AppSettings(false, true)), 
    HIVE_SecureCredentials('', '', ''));
  print('saving metadata template');
  await data.put('metadata', hive_metadata);
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