import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gbevplan/components/popUp.dart';
import 'package:gbevplan/theme/colors.dart';
import 'package:gbevplan/theme/sizes.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:webview_flutter/webview_flutter.dart';

class OrgTimeTable extends StatefulWidget {
  const OrgTimeTable({super.key});

  @override
  State<OrgTimeTable> createState() => _OrgTimeTableState();
}

class _OrgTimeTableState extends State<OrgTimeTable> with SingleTickerProviderStateMixin {

  late AnimationController _controllerLoadingBar;

  WebViewController _controllerWebView = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(const Color(0x00000000))
    ..enableZoom(true);

  @override
  void initState() {
    _controllerLoadingBar = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
      value: 0
    );

    _controllerWebView.setNavigationDelegate(
      NavigationDelegate(
        onWebResourceError: (error) {
          PopUp.create(context, 3, error.errorCode.toString(), error.description.toString());
        },
        onPageStarted: (url) {
          setState(() {
            _controllerLoadingBar.value = 0;
            _controllerLoadingBar.animateTo(0.75);
          });
        },
        onPageFinished: (url) {
          setState(() {
            _controllerLoadingBar.animateTo(1);
          });
        },
        onNavigationRequest: (request) {
          return NavigationDecision.prevent;
        },
      )
    );

    _controllerWebView.clearCache();
    _controllerWebView.loadRequest(Uri.parse('https://rolanddaum.github.io/gbevplan/'));

    super.initState();
  }

  @override
  void dispose() {
    _controllerLoadingBar.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        refreshBar(),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 5).add(EdgeInsets.only(top: 0, bottom: 5)),
          height: 45,
          width: 300,
          decoration: BoxDecoration(
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector( // onTap -> Change VPlan
                onTap: () {
                  _controllerWebView.clearCache();
                  _controllerWebView.loadRequest(Uri.parse('https://rolanddaum.github.io/gbevplan/'));
                },
                child: SvgPicture.asset('assets/icons/arrowleftfilled.svg'),
              ),
              SizedBox(width: 15,),
              Text(
                'VPlan - 12/03/2024',
                style: TextStyle(
                  color: AppColor.Font
                ),
              ),
              SizedBox(width: 15,),
              GestureDetector( // onTap -> Change VPlan
                child: SvgPicture.asset('assets/icons/arrowrightfilled.svg'),
              )
            ],
          ),
        ),   
        Expanded(
          child: Container(
              margin: EdgeInsets.only(bottom: 25).add(EdgeInsets.symmetric(horizontal: 10)),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSizes.BorderRadiusNormal)
              ),
              child: WebViewWidget(
                controller: _controllerWebView,
              ),
            ),
          )
      ],
    );
  }

  // Top Refresh Bar
  Padding refreshBar() {
    return Padding(
          // padding: EdgeInsets.only(top: 5).add(EdgeInsetsDirectional.symmetric(horizontal: 5)),
          padding: EdgeInsets.all(5),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned.fill( // nicht expanded
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 1.5),
                  child: Container(
                    height: 1,
                    decoration: BoxDecoration(
                      color: AppColor.FontUnfocused,
                      borderRadius: BorderRadius.circular(AppSizes.BorderRadiusLarge)
                    ),
                  ),
                ),
              ),
              
              AnimatedBuilder(
                animation: _controllerLoadingBar,
                builder: (context, child) {
                  return LinearProgressIndicator(
                    value: _controllerLoadingBar.value,
                    backgroundColor: AppColor.transparent,  
                    valueColor: AlwaysStoppedAnimation<Color>(AppColor.AccentBlue),
                    minHeight: 4,
                    borderRadius: BorderRadius.circular(AppSizes.BorderRadiusLarge),
                  );
                },
              ),
            ],
          )
        );
  }
}