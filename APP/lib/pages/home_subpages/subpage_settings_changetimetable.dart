import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gbevplan/code/normTTCalc.dart';
import 'package:gbevplan/pages/home_subpages/page_news.dart';
import 'package:gbevplan/pages/home_subpages/page_settings_changetimetable_subjects.dart';
import 'package:gbevplan/pages/home_subpages/page_settings_changetimetable_weekday.dart';
import 'package:gbevplan/pages/home_subpages/page_timetable.dart';
import 'package:gbevplan/theme/colors.dart';
import 'package:gbevplan/theme/sizes.dart';

class page_ChangeTimetable extends StatefulWidget {
  const page_ChangeTimetable({super.key});

  @override
  State<page_ChangeTimetable> createState() => _ChangeTimetableState();
}

class _ChangeTimetableState extends State<page_ChangeTimetable> {
  late PageController pageviewController;
  late ScrollController listscrollController;

  // State Var
  List<String> horizontalSelectionList = ['Subjects', 'Montag', 'Dienstag', 'Mittwoch', 'Donnerstag', 'Freitag'];
  int currentSelection = 0;
  bool tabselection = false;

  @override
  void initState() {
    listscrollController = ScrollController();

    pageviewController = PageController(
      keepPage: true,
      initialPage: currentSelection
    );
    pageviewController.addListener(() {
      setState(() {
        if (!tabselection) {
          currentSelection = pageviewController.page!.round();
          // listscrollController.animateTo(currentSelection.toDouble() * 30, duration: Duration(milliseconds: 50), curve: Curves.easeInOutCubic);
        }
      });
      listscrollController.animateTo(currentSelection.toDouble() * 30, duration: Duration(milliseconds: 50), curve: Curves.easeInOutCubic);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container( // Horizontal Scroll List
          margin: EdgeInsets.symmetric(horizontal: 20).add(EdgeInsets.only(top: 25)),
          height: 30,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSizes.BorderRadiusNormal)
          ),
          // width: 300,
          child: ListView.builder(
            controller: listscrollController,
            padding: EdgeInsets.zero,
            scrollDirection: Axis.horizontal,
            itemCount: 6,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  int delta = (currentSelection-index).abs();
                  currentSelection = index;
                  setState(() {
                    tabselection = true;
                    pageviewController.animateToPage(index, duration: Duration(milliseconds: delta*200), curve: Curves.easeInOutCubic).then(
                      (value) {
                        tabselection = false;
                      }
                    );
                  });
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 2),
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  height: 10,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: index == currentSelection ? AppColor.AccentBlue : AppColor.backgroundLight,
                    borderRadius: BorderRadius.circular(1000)
                  ),
                  child: Text(
                    horizontalSelectionList[index],
                    style: TextStyle(
                      color: index == currentSelection ? AppColor.FontSecondary : AppColor.Font,
                      fontSize: 12.5,
                      // fontWeight: index == currentSelection ? FontWeight.w500 : FontWeight.w200 
                    ),
                  ),
                ),
              );
            }
          )
        ),
        Container( // Seperating Line
          margin: EdgeInsets.symmetric(vertical: 25, horizontal: 30),
          height: 1,
          decoration: BoxDecoration(
            color: AppColor.LightBorder
          ),
        ),
        Expanded(
          child: PageView(
            controller: pageviewController,
            children: [
              page_settings_changetimetable_subjects(),
              page_settings_changetimetable_weekday(weekday: 1,),
              page_settings_changetimetable_weekday(weekday: 2,),
              page_settings_changetimetable_weekday(weekday: 3,),
              page_settings_changetimetable_weekday(weekday: 4,),
              page_settings_changetimetable_weekday(weekday: 5,),
            ],
          )
        )
      ],
    );
 }
}