import 'dart:convert';
import 'dart:nativewrappers/_internal/vm/lib/ffi_allocation_patch.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:firebase_database/firebase_database.dart';

class HomeOGTimeTable extends StatefulWidget {
  const HomeOGTimeTable({super.key});

  @override
  State<HomeOGTimeTable> createState() => _HomeOGTimeTableState();
}

class _HomeOGTimeTableState extends State<HomeOGTimeTable> {
  late BuildContext globContext;

  List<String> uuidList = List.empty();
  int selectedUUID = 0;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() {
    FirebaseDatabase.instance.ref('/URL').once().then((DatabaseEvent event) {
      final data = event.snapshot.value as List<dynamic>;
      setState(() {
        uuidList = data
            .map((item) => (item as Map<dynamic, dynamic>)['uuid'] as String)
            .toList();
        updateSide();
      });
      // ignore: invalid_return_type_for_catch_error
    }).catchError((error) =>
        {print('An Error occoured: $error'), Navigator.pop(context)});
  }

  void updateSide() {
    setState(() {
      _webviewController.loadRequest(Uri.parse(
          'https://dsbmobile.de/data/a2223098-b91f-4526-b48d-55af00305b46/${uuidList.elementAt(selectedUUID)}/${uuidList.elementAt(selectedUUID)}.htm'));
    });
    print(selectedUUID);
  }

  @override
  void deactivate() {
    super.deactivate();

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor:
            Theme.of(globContext).colorScheme.surfaceContainer));
  }

  final WebViewController _webviewController = WebViewController()
    // ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(Colors.transparent)
    ..setNavigationDelegate(
      NavigationDelegate(
        // onProgress: (int progress) {
        //   // print("|-|-|-| - " + progress.toString());
        // },
        // onPageStarted: (String url) {},
        // onPageFinished: (String url) {},
        // onHttpError: (HttpResponseError error) {},
        // onWebResourceError: (WebResourceError error) {},
        // onNavigationRequest: (NavigationRequest request) {},
        onNavigationRequest: (request) {
          return NavigationDecision.prevent;
        },
      ),
    )
    ..clearLocalStorage()
    ..clearCache();
  // ..loadRequest(Uri.parse('https://rolanddaum.github.io/gbevplan/'));

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    globContext = context;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: Theme.of(globContext).colorScheme.surface));

    return Scaffold(
      appBar: AppBar(
        actions: [
          GestureDetector(
            onTap: () {
              setState(() {
                selectedUUID = (selectedUUID - 1 < 0)
                    ? (uuidList.length - 1)
                    : (selectedUUID - 1);
                updateSide();
              });
            },
            child: const Icon(Icons.arrow_back_ios_rounded),
          ),
          const SizedBox(width: 16),
          GestureDetector(
            onTap: () {
              setState(() {
                selectedUUID = (selectedUUID + 1 >= uuidList.length)
                    ? 0
                    : (selectedUUID + 1);
                updateSide();
              });
            },
            child: const Icon(Icons.arrow_forward_ios_rounded),
          ),
          const SizedBox(width: 16),
        ],
        systemOverlayStyle: SystemUiOverlayStyle(
            // If the scafflod uses an appBar, the system Overlay Style has to be declerated in it else just do it over chromeoption thing what ever, befor returning inside the build method
            systemNavigationBarColor: Theme.of(context).colorScheme.surface),
        title: const Text("Montag - 13:28"),
      ),
      body: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: WebViewWidget(controller: _webviewController)),
    );
  }
}
