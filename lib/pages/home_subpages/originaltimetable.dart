import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gbevplan/components/popUp.dart';
import 'package:gbevplan/theme/colors.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:webview_flutter/webview_flutter.dart';

class OrgTimeTable extends StatefulWidget {
  const OrgTimeTable({super.key});

  @override
  State<OrgTimeTable> createState() => _OrgTimeTableState();
}

class _OrgTimeTableState extends State<OrgTimeTable> {
  WebViewController controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(const Color(0x00000000))
    ..enableZoom(true)
    // ..loadRequest(Uri.parse('https://www.dsbmobile.de/Login.aspx?U=346481&P=gbevplan'));
    ..loadRequest(Uri.parse('http://daum-schwagstorf.ddns.net:5500/'));

  @override
  void initState() {
    controller.setNavigationDelegate(
      NavigationDelegate(
        onNavigationRequest: (request) {
          return NavigationDecision.prevent;
        }
      )
    );


    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 45,
          width: 300,
          decoration: BoxDecoration(
            color: Colors.grey[100]
          ),
        ),
        Expanded(
          child: WebViewWidget(
            controller: controller
          )
        )
      ],
    );
  }
}