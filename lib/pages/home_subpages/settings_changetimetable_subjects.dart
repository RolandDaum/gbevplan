import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gbevplan/theme/colors.dart';
import 'package:gbevplan/theme/sizes.dart';

class page_settings_changetimetable_subjects extends StatefulWidget {
  const page_settings_changetimetable_subjects({super.key});

  @override
  State<page_settings_changetimetable_subjects> createState() => _page_settings_changetimetable_subjectsState();
}

class _page_settings_changetimetable_subjectsState extends State<page_settings_changetimetable_subjects> {

  // State var
  List<Map<String, bool>> jahrgangList = [
    {'Jahrgang 5': false},
    {'Jahrgang 6': false},
    {'Jahrgang 7': false},
    {'Jahrgang 8': false},
    {'Jahrgang 9': false},
    {'Jahrgang 11': false},
    {'Jahrgang 12': true},
    {'Jahrgang 13': false},
  ];
  bool showJahrgangList = false;
  int currentSelectionJahrgangList = 6;



  @override
  void initState() {

    print('I N I T');

    super.initState();
  }

  @override
  void dispose() {
    // on weekday dispose save data in hive
    print('D I S P O S E D'); 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30).add(EdgeInsets.only(bottom: 25)),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: BoxDecoration(
        // border: Border.all(color: Colors.red, width: 1),
        borderRadius: BorderRadius.circular(AppSizes.BorderRadiusNormal)
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            Column( // Jahrgang Selection
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    'Jahrgang',
                    style: TextStyle(
                      color: AppColor.Font
                    ),
                  ),
                ),
                Stack(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          showJahrgangList = !showJahrgangList;
                        });
                      },
                      child: Container(
                      height: 45,
                      decoration: BoxDecoration(
                        color: AppColor.backgroundLight,
                        border: Border.all(color: AppColor.LightBorder, width: 1),
                        borderRadius: BorderRadius.circular(AppSizes.BorderRadiusNormal)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              jahrgangList[currentSelectionJahrgangList].keys.first,
                              style: TextStyle(
                                color: AppColor.Font
                              ),
                            ),
                            SvgPicture.asset('assets/icons/arrowdown.svg')
                          ],
                        ),
                      ),
                    ),
                    ),
                    showJahrgangList ? TapRegion(
                      onTapOutside: (event) {
                        setState(() {
                          showJahrgangList = !showJahrgangList;
                        });
                      },
                      child: Container(
                        height: 45*3.5,
                        decoration: BoxDecoration(
                          color: AppColor.backgroundLight,
                          border: Border.all(color: AppColor.LightBorder, width: 1),
                          borderRadius: BorderRadius.circular(AppSizes.BorderRadiusNormal)
                        ),
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: jahrgangList.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                if (jahrgangList[index].values.first) {
                                  setState(() {
                                    currentSelectionJahrgangList = index;
                                    showJahrgangList = false;
                                  });
                                }
                              },
                              child: Container(
                                height: 45-8,
                                margin: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: currentSelectionJahrgangList == index ? AppColor.backgroundDark : AppColor.transparent,
                                  borderRadius: BorderRadius.circular(AppSizes.BorderRadiusSmall)
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 45/3,
                                      width: 3,
                                      margin: EdgeInsets.only(right: 10),
                                      decoration: BoxDecoration(
                                        color: currentSelectionJahrgangList == index ? AppColor.AccentBlue : AppColor.transparent,
                                        borderRadius: BorderRadius.circular(1000)
                                      ),
                                    ),
                                    Text(
                                      jahrgangList[index].keys.first,
                                      style: TextStyle(
                                        color: jahrgangList[index].values.first ? AppColor.Font : AppColor.FontUnfocused
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                            
                          },
                        ),
                      )
                  ) : SizedBox()
                    
                  ],
                )
              ],
            ),
            Container( // Seperating Line
              margin: EdgeInsets.symmetric(vertical: 25,),
              height: 1,
              decoration: BoxDecoration(
                color: AppColor.LightBorder
              )
            ),
            ListView.builder( // Subject List
              padding: EdgeInsets.zero,
              itemCount: 10,
              shrinkWrap: true,
              // primary: false,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.green[100]
                  ),
                  child: Center(child: Text(index.toString())),
                );
              },
            ),
            Container( // Jahrgang selection
              height: 45,
              decoration: BoxDecoration(
                color: Colors.red[100]
              ),
            ),

          ],
        ),
      )
    );
  }
}