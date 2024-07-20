import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  Future<bool> login() async {
    bool valid = true;
    await FirebaseDatabase.instance
        .ref('/credentials/username')
        .once()
        .then((DatabaseEvent event) {
      String username = event.snapshot.value as String;
      if (username != tecUsername.text) {
        valid = false;
      }
    });
    await FirebaseDatabase.instance
        .ref('/credentials/password')
        .once()
        .then((DatabaseEvent event) {
      String password = event.snapshot.value as String;
      if (password != tecPassword.text) {
        valid = false;
      }
    });
    return valid;
  }

  @override
  void dispose() {
    super.dispose();

    var appdataBOX = Hive.box("appdata");
    appdataBOX.put("rememberme", _remmevalue);
    if (_remmevalue) {
      appdataBOX.put("username", tecUsername.text);
      appdataBOX.put("password", tecPassword.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: Theme.of(context).colorScheme.surface,
        statusBarColor: Theme.of(context).colorScheme.surface));

    return Scaffold(
      // resizeToAvoidBottomInset: true,
      extendBody: true,
      // extendBodyBehindAppBar: true,
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
                            login().then((valid) {
                              if (valid) {
                                Fluttertoast.showToast(
                                  msg: "valid",
                                  toastLength: Toast.LENGTH_SHORT,
                                  backgroundColor: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
                                  textColor: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer,
                                );
                                Hive.box("appdata").get("initBoot")
                                    ? Navigator.of(context).popAndPushNamed(
                                        '/home') // TODO: Change back to "/setuptuto" for intoductory pages
                                    : Navigator.of(context)
                                        .popAndPushNamed('/home');
                              } else {
                                Fluttertoast.showToast(
                                  msg: "incorrect credentials",
                                  toastLength: Toast.LENGTH_SHORT,
                                  backgroundColor: Theme.of(context)
                                      .colorScheme
                                      .errorContainer,
                                  textColor: Theme.of(context)
                                      .colorScheme
                                      .onErrorContainer,
                                );
                              }
                            })
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
