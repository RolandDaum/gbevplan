import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gbevplan/pages/home_subpages/timetable.dart';
import 'package:gbevplan/theme/colors.dart';
import 'package:gbevplan/theme/sizes.dart';
import 'package:go_router/go_router.dart';

class page_Home extends StatefulWidget {
  final Widget child;

  const page_Home({super.key, required this.child});

  @override
  State<page_Home> createState() {
    return page_HomeState();
  }
}

class page_HomeState extends State<page_Home> {

  double icon_padding = 11;
  String current_route = '';


  @override
  void initState() {
    updateRoute();
    super.initState();
  }

  void updateRoute() {
    current_route = GoRouter.of(context).routeInformationProvider.value.uri.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundDark,
      body: Column(
        children: [
          Container(
                height: 25,
                decoration: BoxDecoration(
                  color: AppColor.backgroundLight
                ),
              ),
          Expanded(
            child: Row(
            children: [
              Container( // Sidebar
                width: 50,
                decoration: BoxDecoration(
                  color: AppColor.backgroundLight
                ),
                child: Column( // Top and Bottom
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                      ),
                      child: Column(
                        children: [
                          // SizedBox(height: 25,),
                          GestureDetector( // timetable (HOME)
                            onTap: () {
                              context.go('/timetable');
                              setState(() {
                                updateRoute();
                              });
                            },
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    color: current_route == '/timetable' ? AppColor.backgroundDark : AppColor.transparent,
                                    borderRadius: BorderRadius.circular(AppSizes.BorderRadiusNormal)
                                  ),
                                ), // Background
                                Container(
                                  alignment: Alignment.centerLeft,
                                  width: 39,
                                  height: 39,
                                  child: Container(
                                    height: 22.5,
                                    width: 3,
                                    decoration: BoxDecoration(
                                      color: current_route == '/timetable' ? AppColor.AccentBlue : AppColor.transparent,
                                      borderRadius: BorderRadius.circular(AppSizes.BorderRadiusLarge)
                                    ),
                                  )
                                ), // Blue Border side
                                Padding(
                                  padding: EdgeInsets.all(icon_padding),
                                  child: SvgPicture.asset('assets/icons/sidebar/sidebar_home.svg'),
                                ) // Icon
                              ],
                            ),
                          ),
                          GestureDetector( // news
                            onTap: () {
                              context.go('/news');
                              setState(() {
                                updateRoute();
                              });
                            },
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    color: current_route == '/news' ? AppColor.backgroundDark : AppColor.transparent,
                                    borderRadius: BorderRadius.circular(AppSizes.BorderRadiusNormal)
                                  ),
                                ), // Background
                                Container(
                                  alignment: Alignment.centerLeft,
                                  width: 39,
                                  height: 39,
                                  child: Container(
                                    height: 22.5,
                                    width: 3,
                                    decoration: BoxDecoration(
                                      color: current_route == '/news' ? AppColor.AccentBlue : AppColor.transparent,
                                      borderRadius: BorderRadius.circular(AppSizes.BorderRadiusLarge)
                                    ),
                                  )
                                ), // Blue Border side
                                Padding(
                                  padding: EdgeInsets.all(icon_padding),
                                  child: SvgPicture.asset('assets/icons/sidebar/sidebar_news.svg'),
                                ) // Icon
                              ],
                            ),
                          ),
                          GestureDetector( // settings
                            onTap: () {
                              context.go('/settings');
                              setState(() {
                                updateRoute();
                              });
                            },
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    color: current_route == '/settings' ? AppColor.backgroundDark : AppColor.transparent,
                                    borderRadius: BorderRadius.circular(AppSizes.BorderRadiusNormal)
                                  ),
                                ), // Background
                                Container(
                                  alignment: Alignment.centerLeft,
                                  width: 39,
                                  height: 39,
                                  child: Container(
                                    height: 22.5,
                                    width: 3,
                                    decoration: BoxDecoration(
                                      color: current_route == '/settings' ? AppColor.AccentBlue : AppColor.transparent,
                                      borderRadius: BorderRadius.circular(AppSizes.BorderRadiusLarge)
                                    ),
                                  )
                                ), // Blue Border side
                                Padding(
                                  padding: EdgeInsets.all(icon_padding),
                                  child: SvgPicture.asset('assets/icons/sidebar/sidebar_settings.svg'),
                                ) // Icon
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector( // questions
                      onTap: () {
                        // context.go('/questions');
                        setState(() {
                          updateRoute();
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                color: current_route == '/questions' ? AppColor.backgroundDark : AppColor.transparent,
                                borderRadius: BorderRadius.circular(AppSizes.BorderRadiusNormal)
                              ),
                            ), // Background
                            Container(
                              alignment: Alignment.centerLeft,
                              width: 39,
                              height: 39,
                              child: Container(
                                height: 22.5,
                                width: 3,
                                decoration: BoxDecoration(
                                  color: current_route == '/questions' ? AppColor.AccentBlue : AppColor.transparent,
                                  borderRadius: BorderRadius.circular(AppSizes.BorderRadiusLarge)
                                ),
                              )
                            ), // Blue Border side
                            Padding(
                              padding: EdgeInsets.all(icon_padding),
                              child: SvgPicture.asset('assets/icons/sidebar/sidebar_questions.svg'),
                            ) // Icon
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: widget.child
              )
            ],
          ),
          )
          ],
      )
    );
  }
}