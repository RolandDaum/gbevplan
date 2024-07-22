import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gbevplan/components/empty_widget.dart';
import 'package:gbevplan/pages/setup_screens/setup_page_courseselection.dart';
import 'package:gbevplan/pages/setup_screens/setup_page_intro.dart';
import 'package:gbevplan/pages/setup_screens/setup_page_jhgselection.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SetupTuto extends StatefulWidget {
  const SetupTuto({super.key});

  @override
  State<SetupTuto> createState() => _SetupTutoState();
}

class _SetupTutoState extends State<SetupTuto> {
  int _currentpage = 0;
  final PageController _controller = PageController();
  final List<Widget> setuppages = [
    const SetupPageIntro(),
    const SetupPageJhgselection(),
    const SetupPageCourseselection()
  ];

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          const EmptyWidget(), // Else the body will clip behind the status bar
      extendBody: false,
      extendBodyBehindAppBar: false,
      body: Stack(children: [
        PageView(
          onPageChanged: (value) {
            setState(() {
              _currentpage = value;
            });
          },
          controller: _controller,
          children: setuppages,
        ),
        Container(
            alignment: const Alignment(0, 0.95),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MaterialButton(
                    onPressed: _currentpage != 0
                        ? () {
                            _controller.animateToPage(
                                _controller.page!.toInt() - 1,
                                duration: Durations.medium1,
                                curve: Curves.easeInOut);
                          }
                        : null,
                    child: _currentpage != 0
                        ? Icon(
                            Icons.arrow_back_ios_rounded,
                            color: Theme.of(context).colorScheme.onSurface,
                          )
                        : Icon(
                            Icons.arrow_back_ios_rounded,
                            color:
                                Theme.of(context).colorScheme.onInverseSurface,
                          )),
                SmoothPageIndicator(
                  controller: _controller,
                  count: setuppages.length,
                  effect: ExpandingDotsEffect(
                      dotColor: Theme.of(context).colorScheme.onSurfaceVariant,
                      activeDotColor: Theme.of(context).colorScheme.primary),
                  onDotClicked: (value) {
                    _controller.animateToPage(value,
                        duration: Durations.medium1, curve: Curves.easeInOut);
                  },
                ),
                MaterialButton(
                    onPressed: _currentpage != setuppages.length - 1
                        ? () {
                            _controller.animateToPage(
                                _controller.page!.toInt() + 1,
                                duration: Durations.medium1,
                                curve: Curves.easeInOut);
                          }
                        : null,
                    child: _currentpage != setuppages.length - 1
                        ? Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Theme.of(context).colorScheme.onSurface,
                          )
                        // : Icon(
                        //     Icons.arrow_forward_ios_rounded,
                        //     color:
                        //         Theme.of(context).colorScheme.onInverseSurface,
                        //   )),
                        : Icon(Icons.check_rounded,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface)) // TODO: Add if else when user entered all required information
              ],
            ))
      ]),
    );
  }
}

// var appdataBOX = Hive.box("appdata");
// appdataBOX.put("initBoot", false);
