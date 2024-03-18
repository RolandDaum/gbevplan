import 'package:flutter/material.dart';
import 'package:gbevplan/dataobj/metadataOBJ.dart';
import 'package:gbevplan/theme/colors.dart';
import 'package:gbevplan/pages/Login.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';

void main() async {
  Hive.registerAdapter(HIVE_MetaDataAdapter());
  await Hive.initFlutter();
  Box<dynamic> boxMetadata = await Hive.openBox('metadata');
  if (boxMetadata.isEmpty) {
    initMetadata(boxMetadata);
  }
  runApp(const MyApp());
}
void initMetadata(Box<dynamic> boxMetadata) {
  HIVE_Metadata hive_metadata = HIVE_Metadata(
    HIVE_UserData('', 0), 
    HIVE_AppData(
      HIVE_AppInfo('1.0.0', 'GBE-VPlan'), 
      HIVE_UIInfo(false), 
      HIVE_APIInfo('', 'domain.com', ''), 
      HIVE_AppSettings(false, true)), 
    HIVE_SecureCredentials('', '', ''));
  boxMetadata.put('metadata', hive_metadata);
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