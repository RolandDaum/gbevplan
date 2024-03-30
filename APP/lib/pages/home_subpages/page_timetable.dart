import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gbevplan/code/normTTCalc.dart';
import 'package:gbevplan/components/popUp.dart';
import 'package:gbevplan/theme/colors.dart';
import 'package:gbevplan/theme/sizes.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';

class page_TimeTable extends StatefulWidget {
  const page_TimeTable({super.key});

  @override
  State<page_TimeTable> createState() => page_TimeTableState();
}

class page_TimeTableState extends State<page_TimeTable> with SingleTickerProviderStateMixin {

  // Hive - Storage
  Box userdata_box = Hive.box('userdata');
  Box appdata_box = Hive.box('appdata');
  Box apidata_box = Hive.box('apidata');

  // Refresh Bar
  late AnimationController _controllerLoadingBar;

  // Date Drop Down
  bool _dropdownmenuIsShowing = false;
  List<String> availableDates = ['23/03/2024', '24/03/2024', '25/03/2024'];
  int selectedDate = 0;

  // Timetable
  late Map<int, Map<int, String>>? normTT;
  List<List<String>> timetableMap = [
    ['000', '---', '---'],
    ['000', '---', '---'],
    ['000', '---', '---'],
    ['000', '---', '---'],
    ['000', '---', '---'],
    ['000', '---', '---'],
    ['000', '---', '---'],
    ['000', '---', '---'],
    ['000', '---', '---'],
    ['000', '---', '---'],
    ['000', '---', '---'],

  ];
  int currentTimeTableMapSelection = 0;
  int currenWeekday = DateTime.now().weekday;

  void refreshData() {
    _controllerLoadingBar.value = 0;
    _controllerLoadingBar.animateTo(1).then((value) {
      PopUp.create(context, 1, 'Refresh', 'successfull refresh');
    });

    // current lesson selection switch
    DateTime currentDT = DateTime.now();

    currentTimeTableMapSelection = -1;

    if (currentDT.isAfter(DateTime(currentDT.year, currentDT.month, currentDT.day, 7,40))) {
      currentTimeTableMapSelection++;
    } if (currentDT.isAfter(DateTime(currentDT.year, currentDT.month, currentDT.day, 8,30))) {
      currentTimeTableMapSelection++;
    } if (currentDT.isAfter(DateTime(currentDT.year, currentDT.month, currentDT.day, 9,35))) {
      currentTimeTableMapSelection++;
    } if (currentDT.isAfter(DateTime(currentDT.year, currentDT.month, currentDT.day, 10,25))) {
      currentTimeTableMapSelection++;
    } if (currentDT.isAfter(DateTime(currentDT.year, currentDT.month, currentDT.day, 11,25))) {
      currentTimeTableMapSelection++;
    } if (currentDT.isAfter(DateTime(currentDT.year, currentDT.month, currentDT.day, 12,15))) {
      currentTimeTableMapSelection++;
    } if (currentDT.isAfter(DateTime(currentDT.year, currentDT.month, currentDT.day, 13,5))) {
      currentTimeTableMapSelection++;
    } if (currentDT.isAfter(DateTime(currentDT.year, currentDT.month, currentDT.day, 13,50))) {
      currentTimeTableMapSelection++;
    } if (currentDT.isAfter(DateTime(currentDT.year, currentDT.month, currentDT.day, 14,35))) {
      currentTimeTableMapSelection++;
    } if (currentDT.isAfter(DateTime(currentDT.year, currentDT.month, currentDT.day, 15,25))) {
      currentTimeTableMapSelection++;
    } if (currentDT.isAfter(DateTime(currentDT.year, currentDT.month, currentDT.day, 16,10))) {
      currentTimeTableMapSelection++;
    } if (currentDT.isAfter(DateTime(currentDT.year, currentDT.month, currentDT.day, 16,55))) {
      currentTimeTableMapSelection = -1;
    }
    setState(() {}); // refresh the ui data
  }

  @override
  void initState() {
    normTT = convertNormTTfromHiveDynMapToMap(appdata_box.get('normtimetable'));
    if (currenWeekday > 5) {
    } else if (normTT != null) {
      for (int i = 0; i < timetableMap.length; i++) {
        timetableMap[i][1] = normTT![currenWeekday]![i+1].toString();
      }
    }

    _controllerLoadingBar = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
      value: 0
    );
    refreshData();

    super.initState();
  }

  @override
  void dispose() {
    _controllerLoadingBar.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double _startY = 0.0;
    double _deltaY = 0.0;

    // M A I N  P A G E
    return GestureDetector(
      // Page Refrsh Detector
      // behavior: HitTestBehavior.translucent,

      onVerticalDragStart: (details) {
        _startY = details.globalPosition.dy;
      },
      onVerticalDragUpdate: (details) {
        double currentY = details.globalPosition.dy;
        _deltaY = currentY - _startY;
      },
      onVerticalDragEnd: (details) {
        int? primvelocity = details.primaryVelocity?.toInt();
        // print(primvelocity.toString() + ' | ' + _deltaY.toString());
        if (primvelocity == null) {return;}
        else if (primvelocity > 500 && _deltaY > 150) {
          refreshData();
        }
      },
        
      // Actual Conten
      child: Column(
        children: [
          refreshBar(),
          Expanded(
            child: Column(
              children: [
                const SizedBox(height: 30,),
                widget_dateDropDown(),
                const SizedBox(height: 30,),
                widget_timeTable(),
                const SizedBox(height: 30,),
                widget_fulltimetablelink()
              ],
            )
          )
        ],
    ),
    );
  }

  // Top Refresh Bar
  Padding refreshBar() {
    return Padding(
          padding: EdgeInsets.only(top: 5).add(EdgeInsetsDirectional.symmetric(horizontal: 5)),
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

  // Remove the dropdown Menu of date select
  void removeDropDownMenu(OverlayEntry? overlayEntry) {
    overlayEntry?.remove();
    overlayEntry?.dispose();
    _dropdownmenuIsShowing = false;
  }
  GestureDetector widget_dateDropDown() {
    return GestureDetector(
      onTap: () {
        if (_dropdownmenuIsShowing) {
          print('There is already a dropdownmenu');
          return;
        }
        _dropdownmenuIsShowing = true;
        OverlayEntry? overlayEntry;
        overlayEntry = OverlayEntry(
          builder: (context) {
            return Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 39),
                child: TapRegion(
                  onTapOutside: (tap) {
                    removeDropDownMenu(overlayEntry);
                    // PopUp.create(context, 2, 'IDK', 'idk long text');
                  },
                  child: Container(
                    width: 225,
                    height: availableDates.length*45+5,
                    decoration: BoxDecoration(
                      color: AppColor.backgroundLight,
                      borderRadius: BorderRadius.circular(AppSizes.BorderRadiusNormal),
                      border: Border.all(color: AppColor.LightBorder, width: 1)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(2.5),
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: availableDates.length,
                        itemBuilder: (context, index) {
                          return Container(
                            width: 225,
                            height: 45,
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.all(2.5),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    removeDropDownMenu(overlayEntry);
                                    selectedDate = index;
                                    refreshData();
                                  });
                                },
                                child: Stack(
                                  alignment: Alignment.centerLeft,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: index == selectedDate ? AppColor.backgroundDark : AppColor.transparent,
                                        borderRadius: BorderRadius.circular(AppSizes.BorderRadiusSmall)
                                      ),
                                    ),
                                    Container(
                                      height: 45/2,
                                      width: 3,
                                      decoration: BoxDecoration(
                                        color: index == selectedDate ? AppColor.AccentBlue : AppColor.transparent,
                                        borderRadius: BorderRadius.circular(100)
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 15),
                                      child: Text(
                                        availableDates[index],
                                        style: TextStyle(
                                          color: AppColor.Font,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16
                                        ),
                                      ),
                                    )
                                  ],  
                                ),
                              )
                            ),
                          );
                        }
                      )
                    )
                  ),
                ),
              )
            );
          }
        );
        Overlay.of(context).insert(overlayEntry);
      },
      child: Container(
        width: 225,
        height: 45,
        decoration: BoxDecoration(
          color: AppColor.backgroundLight,
          borderRadius: BorderRadius.circular(AppSizes.BorderRadiusNormal),
          border: Border.all(color: AppColor.LightBorder)
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: SvgPicture.asset('assets/icons/calender.svg', width: 30,),
            ),
            Expanded(
              child: Text(
                availableDates[selectedDate],
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColor.Font,
                  fontWeight: FontWeight.w400,
                  fontSize: 16
                ),

              )
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: SvgPicture.asset('assets/icons/arrowdown.svg', width: 15,),
            ),
          ],
        ),  
      ),
    );
  }
  Container widget_timeTable() {
    return Container(
      height: timetableMap.length*45,
      width: 300,
      child: ListView.builder(

        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsetsDirectional.all(0), // EdgeInsets.zero
        itemCount: timetableMap.length,
        
        itemBuilder: ((context, index) {

          return Container(
            padding: EdgeInsets.all(0),
            width: 300,
            height: 45,
            decoration: BoxDecoration(
              border: Border(bottom: index == timetableMap.length-1 ? BorderSide(color: AppColor.transparent, width: 1) : BorderSide(color: AppColor.LightBorder, width: 1)) // if last, no border bottom
            ),
            child:  Stack(
              alignment: Alignment.center,
                children: [
                  Container(
                    margin: index == currentTimeTableMapSelection ? EdgeInsets.symmetric(vertical: 5) : EdgeInsets.symmetric(vertical: 0), // change if selected
                    height: 45,
                    width: 300,
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      color: index == currentTimeTableMapSelection ? AppColor.backgroundLight : AppColor.transparent, // change if selected
                      borderRadius: BorderRadius.circular(AppSizes.BorderRadiusSmall)
                    ),
                    child: Container(
                      height: 45/3,
                      width: 3.5,
                      decoration: BoxDecoration(
                        color: index == currentTimeTableMapSelection ? AppColor.AccentBlue : AppColor.transparent,
                        borderRadius: BorderRadius.circular(100)
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(2),
                        child: Container(
                          width: 45,
                          decoration: BoxDecoration(),
                          child: Text(
                            timetableMap[index][0].toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: index >= currentTimeTableMapSelection ? AppColor.Font : AppColor.FontUnfocused,
                              fontWeight: index == currentTimeTableMapSelection ? FontWeight.w600 : FontWeight.w400
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 45,
                        decoration: BoxDecoration(
                          color: index == currentTimeTableMapSelection ? AppColor.transparent : AppColor.LightBorder // if selected no background
                        ),
                      ),
                      Expanded(
                        child:Padding(
                          padding: EdgeInsets.only(left: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                timetableMap[index][1].toString(),
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: index >= currentTimeTableMapSelection ? AppColor.Font : AppColor.FontUnfocused,
                                  fontSize: index == currentTimeTableMapSelection ? 20 : 15,
                                  fontWeight: index == currentTimeTableMapSelection ? FontWeight.w600 : FontWeight.w400
                                ),
                              ),
                              Text(
                                timetableMap[index][2].toString(),
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  color: AppColor.FontUnfocused,
                                  fontSize: 13,
                                  decoration: TextDecoration.lineThrough,
                                  decorationColor: AppColor.Font
                                ),
                              )
                            ],
                          )
                        )
                      ),
                      SizedBox(width: 15,)
                    ],
                  )
                ],
              )
            );
        })
      ),
    );
  }
  GestureDetector widget_fulltimetablelink() {
    return GestureDetector(
      onTap: () {
        context.push('/timetable_original');
      },
      child: Container(
        height: 45,
        width: 225,
        decoration: BoxDecoration(
          color: AppColor.backgroundLight,
          border: Border.all(color: AppColor.LightBorder, width: 1),
          borderRadius: BorderRadius.circular(AppSizes.BorderRadiusNormal)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                'Full Timetable',
                style: TextStyle(
                  color: AppColor.AccentHyperlink,
                  decoration: TextDecoration.underline,
                  decorationColor: AppColor.AccentHyperlink
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: SvgPicture.asset('assets/icons/hyperlink.svg'),
            )
          ],
        ),
      ),
    );
  }
}