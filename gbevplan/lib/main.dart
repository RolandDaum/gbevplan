import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gbevplan/firebase_options.dart';
import 'package:gbevplan/pages/home_screens/home_screen.dart';
import 'package:gbevplan/pages/home_screens/home_page_news.dart';
import 'package:gbevplan/pages/home_screens/home_page_ogtimetable.dart';
import 'package:gbevplan/pages/home_screens/home_page_settings.dart';
import 'package:gbevplan/pages/home_screens/settings_screens/settings_page_changeseedcolor.dart';
import 'package:gbevplan/pages/home_screens/settings_screens/settings_page_edittimetable.dart';
import 'package:gbevplan/pages/login.dart';
import 'package:gbevplan/pages/intro_screens/intro_start_screen.dart';
import 'package:gbevplan/pages/oldappversion_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // print("ON BACKGROUNDMESSAGE");
  // print(message.notification?.title);

  // TODO: Process the new data
  await Future.delayed(const Duration(seconds: 5));

  // https://www.youtube.com/watch?v=MTGAFvF1qVI&ab_channel=HussainMustafa
  if (message.notification?.title != null) {
    AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: 123,
            channelKey: "localchannel",
            title: "U P D A T E D  -  T I M E T A B L E",
            body: "t i m e t a b l e"));
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // HIVE initialization
  await Hive.initFlutter();
  await Hive.openBox("appdata").then((box) async {
    if (box.isEmpty) {
      await appInit();
    }
  });

  // Local Notification
  await AwesomeNotifications().initialize(null, [
    NotificationChannel(
        channelGroupKey: "localChannel_Group",
        channelKey: "localchannel",
        channelName: "Local Notification Channel",
        channelDescription: "Local Notification Channel"),
    // icon: ""
  ], channelGroups: [
    NotificationChannelGroup(
        channelGroupKey: "localChannel_Group",
        channelGroupName: "Local Notification Channel Group")
  ]);
  if (!await AwesomeNotifications().isNotificationAllowed()) {
    AwesomeNotifications().requestPermissionToSendNotifications();
  }

  // F I R E B A S E - M E S S A G I N G
  // await FirebaseMessaging.instance.requestPermission(
  //     // alert: true,
  //     // announcement: false,
  //     // badge: true,
  //     // carPlay: false,
  //     // criticalAlert: false,
  //     // provisional: false,
  //     // sound: true,
  //     );
  // FirebaseMessaging.instance.subscribeToTopic("everyone");
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    // print("ON MESSAGE");
    navigatorKey.currentState?.pushNamed("/PAGE_TEST",
        arguments: "YOU GOT A NOTIFICATION WHILE BEING INSIDE THE APP");
  });
  FirebaseMessaging.onMessageOpenedApp.listen((message) {
    // print("ON MESSAGE opend APP");
    navigatorKey.currentState
        ?.pushNamed("/PAGE_TEST", arguments: "YOU TAPPED ON THE NOTIFICATION");
  });
  FirebaseMessaging.instance.getToken().then((token) {
    // print(token);
  });

  await FirebaseDatabase.instance
      .ref('/data/appversion')
      .once()
      .then((DatabaseEvent event) async {
    // print(event.snapshot.value as String);
    Hive.box("appdata")
        .put("newest_appversion", event.snapshot.value as String);
  });

  runApp(const MainGBEVplan());
}

Future<void> appInit() async {
  // print("app init");
  FirebaseMessaging.instance.subscribeToTopic("everyone");
  var appdataBOX = Hive.box("appdata");
  appdataBOX.put("appversion", "0.0.1");

  appdataBOX.put("rememberme", false);
  appdataBOX.put("schulstufe", null);
  appdataBOX.put("initBoot", true);
  appdataBOX.put("thememode", "system");
}

class MainGBEVplan extends StatefulWidget {
  const MainGBEVplan({super.key});

  @override
  State<MainGBEVplan> createState() => MainGBEVplanState();
}

class MainGBEVplanState extends State<MainGBEVplan> {
  bool savedSeedColor = false;
  late Box appdataBox = Hive.box("appdata");
  late ThemeMode loadedThemeMode;
  String local_appversion = "";
  String newest_appversion = "";

  @override
  initState() {
    super.initState();
    local_appversion = appdataBox.get("appversion");
    newest_appversion = appdataBox.get("newest_appversion");

    // print([local_appversion, newest_appversion]);

    _callFunction();

    if (appdataBox.get("seedcolor_red") != null) {
      savedSeedColor = true;
    }

    // print(appdataBox.get("thememode") as String);
    switch (appdataBox.get("thememode").toString()) {
      case "light":
        loadedThemeMode = ThemeMode.light;
        SystemChrome.setSystemUIOverlayStyle(
            const SystemUiOverlayStyle(statusBarBrightness: Brightness.light));
        break;
      case "dark":
        loadedThemeMode = ThemeMode.dark;
        SystemChrome.setSystemUIOverlayStyle(
            const SystemUiOverlayStyle(statusBarBrightness: Brightness.dark));
        break;
      case "system":
        loadedThemeMode = ThemeMode.system;
        break;
      default:
        loadedThemeMode = ThemeMode.system;
        break;
    }
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
    // await FirebaseFunctions.instanceFor(region: 'us-central1')
    //     .httpsCallable('UUIDFunctionOnCall')
    //     .call()
    //     .then((value) => {print("C A L L E D")})
    //     .onError((e, s) => {print(e)});
  }

  @override
  void dispose() {
    super.dispose();

    // // set to false, when completed setup tuto
    // var appdataBOX = Hive.box("appdata");
    // appdataBOX.put("initBoot", false);
  }

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
        builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
      return MaterialApp(
        navigatorKey: navigatorKey,

        title: 'Flutter Demo',
        theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.light,
            fontFamily: GoogleFonts.mPlusRounded1c().fontFamily,
            colorSchemeSeed: savedSeedColor
                ? Color.fromRGBO(
                    appdataBox.get("seedcolor_red"),
                    appdataBox.get("seedcolor_green"),
                    appdataBox.get("seedcolor_blue"),
                    1)
                : lightDynamic != null
                    ? lightDynamic.primary
                    : const Color(0xFF002A68)),
        darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            fontFamily: GoogleFonts.mPlusRounded1c().fontFamily,
            colorSchemeSeed: savedSeedColor
                ? Color.fromRGBO(
                    appdataBox.get("seedcolor_red"),
                    appdataBox.get("seedcolor_green"),
                    appdataBox.get("seedcolor_blue"),
                    1)
                : darkDynamic != null
                    ? darkDynamic.primary
                    : const Color(0xFF002A68)),
        themeMode: loadedThemeMode,
        debugShowCheckedModeBanner: false,
        // debugShowMaterialGrid: true,
        initialRoute: newest_appversion == local_appversion &&
                newest_appversion.isNotEmpty
            ? '/'
            : '/oldappversion',
        routes: {
          '/': (context) => const page_login(),
          '/oldappversion': (context) => const OldappversionScreen(),
          '/home': (context) => const Home(),
          '/home/settings': (context) => const HomeSettings(),
          '/home/settings/editttb': (context) => const Editttb(),
          '/home/settings/changeseedcolor': (context) =>
              const Changeseedcolor(),
          '/home/news': (context) => const HomeNews(),
          '/home/ogtt': (context) => const HomeOGTimeTable(),
          '/introstart': (context) => const IntroStartScreen(),
        },
      );
    });
  }
}
