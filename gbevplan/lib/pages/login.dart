import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:gbevplan/main.dart';
import 'package:hive/hive.dart';
import 'package:fluttertoast/fluttertoast.dart';

// ignore: camel_case_types
class page_login extends StatefulWidget {
  const page_login({super.key});

  @override
  State<page_login> createState() => _page_loginState();
}

// ignore: camel_case_types
class _page_loginState extends State<page_login> {
  bool _remmevalue = false;
  TextEditingController tecUsername = TextEditingController();
  TextEditingController tecPassword = TextEditingController();
  Box appdataBOX = Hive.box("appdata");

  @override
  void initState() {
    super.initState();

    var appdataBOX = Hive.box("appdata");
    _remmevalue = appdataBOX.get("rememberme");

    if (_remmevalue) {
      tecUsername.text = appdataBOX.get("username").toString();
      tecPassword.text = appdataBOX.get("password").toString();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is String) {
      switch (args) {
        case "qlogin":
          if (appdataBOX.get("rememberme")) {
            login(
                username: appdataBOX.get("username"),
                password: appdataBOX.get("password"),
                openOGTTBL: true);
          }
          break;
        default:
          break;
      }
    }
  }

  // ToDo: Add option for usage without login (maybe)
  // ToDo: Add auto login functionallity
  static Future<bool> login(
      {required String username,
      required String password,
      bool openOGTTBL = false}) async {
    bool valid = true;
    await FirebaseDatabase.instance
        .ref('/credentials/username')
        .once()
        .then((DatabaseEvent event) {
      String _username = event.snapshot.value as String;
      if (_username != username) {
        valid = false;
      }
    });
    await FirebaseDatabase.instance
        .ref('/credentials/password')
        .once()
        .then((DatabaseEvent event) {
      String _password = event.snapshot.value as String;
      if (_password != password) {
        valid = false;
      }
    });

    if (valid) {
      Fluttertoast.showToast(
        msg: "valid",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor:
            Theme.of(navigatorKey.currentContext!).colorScheme.primaryContainer,
        textColor: Theme.of(navigatorKey.currentContext!)
            .colorScheme
            .onPrimaryContainer,
      );
      Hive.box("appdata").get("initBoot")
          ? Navigator.of(navigatorKey.currentContext!)
              .popAndPushNamed('/introstart')
          : Navigator.of(navigatorKey.currentContext!)
              .popAndPushNamed('/home')
              .then((value) {
              openOGTTBL
                  ? Navigator.of(navigatorKey.currentContext!)
                      .pushNamed("/home/ogtt")
                  : {};
            });
    } else {
      Fluttertoast.showToast(
        msg: "incorrect credentials",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor:
            Theme.of(navigatorKey.currentContext!).colorScheme.errorContainer,
        textColor:
            Theme.of(navigatorKey.currentContext!).colorScheme.onErrorContainer,
      );
    }
    return valid;
  }

  @override
  void dispose() {
    super.dispose();

    appdataBOX.put("rememberme", _remmevalue);
    if (_remmevalue) {
      appdataBOX.put("username", tecUsername.text);
      appdataBOX.put("password", tecPassword.text);
    } else {
      appdataBOX.put("username", "");
      appdataBOX.put("password", "");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          toolbarHeight: 0,
          systemOverlayStyle: Theme.of(context)
              .appBarTheme
              .systemOverlayStyle!
              .copyWith(
                systemNavigationBarColor: Theme.of(context).colorScheme.surface,
              )),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            "GBE - VPlan",
            style: Theme.of(context).textTheme.displayMedium,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 56),
            child: Column(
              children: [
                TextField(
                  controller: tecUsername,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: "username"),
                ),
                const SizedBox(height: 26),
                TextField(
                  controller: tecPassword,
                  obscureText: true,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: "password"),
                ),
                const SizedBox(height: 26),
                SizedBox(
                  width: 225,
                  child: FilledButton(
                      onPressed: () => {
                            login(
                                username: tecUsername.text,
                                password: tecPassword.text)
                          },
                      child: Text(
                        "login",
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary),
                      )),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Checkbox(
                        value: _remmevalue,
                        onChanged: (change) => {
                              setState(() {
                                _remmevalue = !_remmevalue;
                              })
                            }),
                    const Text(
                      "remember me",
                      style: TextStyle(),
                    )
                  ],
                )
              ],
            ),
          ),
          const SizedBox.shrink()
        ],
      ),
      bottomNavigationBar: Container(
        height: 35,
        alignment: Alignment.topCenter,
        padding: const EdgeInsetsDirectional.only(bottom: 15),
        child: const Text("made by omg_ot"),
      ),
    );
  }
}
