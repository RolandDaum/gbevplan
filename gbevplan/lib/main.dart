// import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gbevplan/Objects/timetable.dart';
import 'package:gbevplan/Objects/timetable_lesson.dart';
import 'package:gbevplan/Objects/timetable_weekday.dart';
import 'package:gbevplan/firebase_options.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:gbevplan/pages/home_screens/home_screen.dart';
import 'package:gbevplan/pages/home_screens/home_page_stats.dart';
import 'package:gbevplan/pages/home_screens/home_page_ogtimetable.dart';
import 'package:gbevplan/pages/home_screens/home_page_settings.dart';
import 'package:gbevplan/pages/home_screens/settings_screens/settings_page_changeseedcolor.dart';
import 'package:gbevplan/pages/home_screens/settings_screens/settings_page_edittimetable.dart';
import 'package:gbevplan/pages/login.dart';
import 'package:gbevplan/pages/intro_screens/intro_start_screen.dart';
import 'package:gbevplan/pages/oldappversion_screen.dart';
import 'package:gbevplan/pages/setup_screens/setup_start_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // await Future.delayed(const Duration(seconds: 5));
  // https://www.youtube.com/watch?v=MTGAFvF1qVI&ab_channel=HussainMustafa
  // if (message.notification?.title != null) {
  //   // LOCAL NOTIFICATION -> NO USE AT THE TIME BEING
  //   AwesomeNotifications().createNotification(
  //       content: NotificationContent(
  //           id: 123,
  //           channelKey: "localchannel",
  //           title: "U P D A T E D  -  T I M E T A B L E",
  //           body: "t i m e t a b l e"));
  // }
}

void main() async {
  // FLUTTER / FIREBASE INIT
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // HIVE INIT
  await Hive.initFlutter();
  Hive.registerAdapter(TimetableAdapter());
  Hive.registerAdapter(TimetableWeekdayAdapter());
  Hive.registerAdapter(TimetableLessonAdapter());

  // APPDATA INIT
  await Hive.openBox("appdata").then((box) async {
    if (box.isEmpty) {
      await appInit();
    }
  });

  // LOCAL NOTIFICATION INIT
  // AwesomeNotifications().initialize(null, [
  //   NotificationChannel(
  //       channelGroupKey: "localChannel_Group",
  //       channelKey: "localchannel",
  //       channelName: "Local Notification Channel",
  //       channelDescription: "Local Notification Channel"),
  //   // icon: ""
  // ], channelGroups: [
  //   NotificationChannelGroup(
  //       channelGroupKey: "localChannel_Group",
  //       channelGroupName: "Local Notification Channel Group")
  // ]);
  // if (!await AwesomeNotifications().isNotificationAllowed()) {
  //   AwesomeNotifications().requestPermissionToSendNotifications();
  // }

  // FIREBASE MESSAGING INIT
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // Triggers when getting a notification while being inside the app && after tapping a notification recieved outside the app
  // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //   print("ON MESSAGE");
  //   // navigatorKey.currentState?.pushNamed("/",
  //   //     arguments: "YOU GOT A NOTIFICATION WHILE BEING INSIDE THE APP");
  // });
  // FirebaseMessaging.instance.getInitialMessage().then((initMessage) {
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     print("App opened from terminated state by clicking on a notification");
  //     navigatorKey.currentState
  //         ?.pushNamed("/", arguments: "qlogin");
  //   });
  // });
  // Triggers when clicking on a notification recived outside the app
  FirebaseMessaging.onMessageOpenedApp.listen((message) async {
    // print("ON MESSAGE OPENED APP");
    // Wait until all widgets are init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // remove until func returns bool true
      navigatorKey.currentState?.popUntil((route) {
        switch (route.settings.name) {
          case "/home/ogtt":
            return true;
          case "/home":
            navigatorKey.currentState?.pushNamed("/home/ogtt");
            return true;
        }
        if (route.isFirst && route.isCurrent) {
          navigatorKey.currentState
              ?.pushReplacementNamed("/", arguments: "qlogin");
          return true;
        }
        return false;
      });

      // if (navigatorKey.currentState == null) {
      //   print("ModalRoute.of(navigatorKey.currentState!.context) == null " +
      //       (ModalRoute.of(navigatorKey.currentState!.context) == null)
      //           .toString());
      //   navigatorKey.currentState?.pushNamed("/", arguments: "qlogin");
      // }
      // else {
      //   switch (ModalRoute.of(navigatorKey.currentState!.context)!
      //       .settings
      //       .name
      //       .toString()) {
      //     case "/home":
      //       navigatorKey.currentState?.pushNamed("/home/ogtt");
      //       break;
      //     default:
      //       navigatorKey.currentState
      //           ?.pushReplacementNamed("/", arguments: "qlogin");
      //       break;
      //   }
      // }
    });
  });
  // FOR DEV PURPOSE ONLY
  // FirebaseMessaging.instance.getToken().then((token) {
  //   print(token);
  // });

  // APPVERSION CHECK
  await FirebaseDatabase.instance
      .ref('/data/appversion')
      .once()
      .then((DatabaseEvent event) async {
    Hive.box("appdata")
        .put("newest_appversion", event.snapshot.value as String);
  });
  // _callOGTTLrefresh();
  // RUN MAIN APP
  runApp(const MainGBEVplan());
}

/// Prepares and adds all nessesary information and data to Hive appdataBox and much more
/// Called on first startup of the app
appInit() async {
  // App persmission request for sending notifications
  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  // Channel/Topic to recieve notifications // All public notificaions are send via this topic
  FirebaseMessaging.instance.subscribeToTopic("everyone");
  var appdataBOX = Hive.box("appdata");
  appdataBOX.put("appversion", "0.0.1");
  appdataBOX.put("rememberme", false);
  appdataBOX.put("schulstufe", null);
  appdataBOX.put("initBoot", true);
  appdataBOX.put("thememode", "system");
  appdataBOX.put("selectedKurse", []);
  appdataBOX.put("jahrgang", 0);
  appdataBOX.put("seedcolor_red", 0);
  appdataBOX.put("seedcolor_green", 51);
  appdataBOX.put("seedcolor_blue", 153);
}

// void _callOGTTLrefresh() async {
//   int timestamp = 0;
//   await FirebaseDatabase.instance.ref("/URL/0/timestamp").once().then((value) =>
//       {
//         value.snapshot.value != null
//             ? timestamp = value.snapshot.value as int
//             : ()
//       });
//   if (timestamp <= DateTime.now().millisecondsSinceEpoch - (5 * 60 * 1000)) {
//     FirebaseFunctions.instanceFor(region: 'us-central1')
//         .httpsCallable('UUIDFunctionOnCall')
//         .call()
//         .then((value) {
//       // print(
//       //     " -  C A L L E D  - "); // triggers when the functions completed to run
//     });
//   }
// }

class MainGBEVplan extends StatefulWidget {
  const MainGBEVplan({super.key});

  @override
  State<MainGBEVplan> createState() => MainGBEVplanState();
}

class MainGBEVplanState extends State<MainGBEVplan> {
  bool savedSeedColor = false;
  Box appdataBox = Hive.box("appdata");
  late ThemeMode loadedThemeMode;
  String localAppversion = "";
  String newestAppversion = "";

  @override
  initState() {
    super.initState();
    localAppversion = appdataBox.get("appversion");
    newestAppversion = appdataBox.get("newest_appversion");
    switch (appdataBox.get("thememode").toString()) {
      case "light":
        loadedThemeMode = ThemeMode.light;
        break;
      case "dark":
        loadedThemeMode = ThemeMode.dark;
        break;
      case "system":
        loadedThemeMode = ThemeMode.system;
        break;
      default:
        loadedThemeMode = ThemeMode.system;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: true,
        fontFamily: GoogleFonts.mPlusRounded1c().fontFamily,
        colorSchemeSeed: Color.fromRGBO(
            appdataBox.get("seedcolor_red"),
            appdataBox.get("seedcolor_green"),
            appdataBox.get("seedcolor_blue"),
            1),
        appBarTheme: AppBarTheme.of(context).copyWith(
            systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarBrightness: Brightness.light,
                statusBarIconBrightness: Brightness.dark,
                statusBarColor: Colors.transparent)),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        fontFamily: GoogleFonts.mPlusRounded1c().fontFamily,
        colorSchemeSeed: Color.fromRGBO(
            appdataBox.get("seedcolor_red"),
            appdataBox.get("seedcolor_green"),
            appdataBox.get("seedcolor_blue"),
            1),
        appBarTheme: AppBarTheme.of(context).copyWith(
            systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarBrightness: Brightness.dark,
                statusBarIconBrightness: Brightness.light,
                statusBarColor: Colors.transparent)),
      ),
      themeMode: loadedThemeMode,
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
              textScaler: const TextScaler.linear(
                  .9)), // FUCKING ACCESSIBILITY SYSTEM SETTINGS
          child: child!,
        );
      },
      initialRoute:
          newestAppversion == localAppversion && newestAppversion.isNotEmpty
              ? '/'
              : '/oldappversion',
      routes: {
        '/': (context) => const page_login(),
        '/oldappversion': (context) => const OldappversionScreen(),
        '/home': (context) => const HomeScreen(),
        '/home/settings': (context) => const HomeSettings(),
        '/home/settings/editttb': (context) => const Editttb(),
        '/home/settings/changeseedcolor': (context) => const Changeseedcolor(),
        '/home/news': (context) => const HomePageStats(),
        '/home/ogtt': (context) => const HomeOGTimeTable(),
        '/introstart': (context) => const IntroStartScreen(),
        '/setupstart': (context) => const SetupStartScreen(),
      },
    );
  }
}
