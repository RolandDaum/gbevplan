import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gbevplan/components/EmptyWidget.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

class HomeOGTimeTable extends StatefulWidget {
  const HomeOGTimeTable({super.key});

  @override
  State<HomeOGTimeTable> createState() => _HomeOGTimeTableState();
}

class _HomeOGTimeTableState extends State<HomeOGTimeTable> {
  late BuildContext globContext;

  @override
  void deactivate() {
    // TODO: implement deactivate
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
        onProgress: (int progress) {
          print("|-|-|-| - " + progress.toString());
        },
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
    ..clearCache()
    ..loadRequest(Uri.parse('https://rolanddaum.github.io/gbevplan/'));

  @override
  Widget build(BuildContext context) {
    globContext = context;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: Theme.of(globContext).colorScheme.surface));

    return Scaffold(
      appBar: AppBar(
        actions: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            child: const Row(
              children: [
                Icon(Icons.arrow_back_ios_rounded),
                SizedBox(width: 16),
                Icon(Icons.arrow_forward_ios_rounded),
              ],
            ),
          )
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
