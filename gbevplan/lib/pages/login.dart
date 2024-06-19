import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore: camel_case_types
class page_login extends StatefulWidget {
  const page_login({super.key});

  @override
  State<page_login> createState() => _page_loginState();
}

// ignore: camel_case_types
class _page_loginState extends State<page_login> {
  bool _remmevalue = false;

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
                const TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: "username"),
                ),
                const SizedBox(height: 26),
                const TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: "password"),
                ),
                const SizedBox(height: 26),
                SizedBox(
                  width: 225,
                  child: FilledButton(
                      onPressed: () =>
                          {Navigator.of(context).popAndPushNamed('/home')},
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
