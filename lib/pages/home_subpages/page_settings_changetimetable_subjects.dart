import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  // - Jahrgang selection -
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

  // - Kurs selection -
  List<String> KursList = [ // Alle Kurse
    "MA1", "MA2", "PH1", "CH1", "BI1", "BI2",
    "DE1", "DE2", "DE3","ENG1", "ENG2", "ENG3","LA1","FR1",
    "EK1", "PW1", "PW2","GE1", "GE2",
    "KU1", "KU2",
    "ma1", "ma2", "ma3", "ma4", "ph1", "bi1", "bi2", "if1", "if2", "ch1",
    "de1", "de2", "eng1", "eng2", "snn1", "la1", "fr1",
    "pw1", "pw2", "ge1", "ge2", "re1", "re2", "rk1", "wn1",
    "mu1", "ku1", "ds1",
    "sp1", "sp2", "sp3", "sp4", "spp1",
    "sf1", "sf2", "sf3", "sf4", "sf5", "sf6"
  ];
  List<String> searchKursList = []; // Alle Kurse, die bei der Suche zutreffen
  late List<String> nonselectedKursList; // Alle Kurse, die noch nicht ausgewählt wurden
  List<String> selectedKursList = []; // Alle Kurse, die ausgewählt wurden
  TextEditingController selectKurs_controller = new TextEditingController();
  FocusNode selectKurs_focusnode = FocusNode();

  @override
  void initState() {
    nonselectedKursList = List.from(KursList);
    searchKursList = List.from(nonselectedKursList);

    selectKurs_controller.addListener(() {
      // search Algo
      setState(() {
        String input = selectKurs_controller.text;
        if (input == '') {
          searchKursList = List.from(nonselectedKursList);
          return;
        }
        searchKursList = [];
        nonselectedKursList.asMap().forEach((index, element) {
          if (element.toLowerCase().contains(input.toLowerCase())) {
            searchKursList.add(element);
          }
        });
      });
    });

    // TODO: Change 'changetimetable' just to timetable and maybe give it a direct link from navbar + add hive storage + rework hive storage system

    super.initState();
  }

  // List<String> sortbyLK(List<String> listtosort) {
  //   List<String> sortedList = [];
  //   listtosort.forEach((element) {
  //     bool isUppperCase = element.toUpperCase() == element;
  //     if (isUppperCase) {
  //       sortedList.add(element);
  //       listtosort.remove(element);
  //     }
  //   });
  //   listtosort.forEach((element) {
  //     sortedList.add(element);
  //   });
  //   return sortedList;
  // }

  @override
  void dispose() {
    // on weekday dispose save data in hive

    selectKurs_controller.dispose();
    selectKurs_focusnode.dispose();

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
          Column( // Kurs Selection
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding( // Title
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  'Kursauswahl',
                  style: TextStyle(
                    color: AppColor.Font
                  ),
                ),
              ),
              TapRegion(
                onTapOutside: (event) {
                  setState(() {
                    selectKurs_focusnode.unfocus();
                  });
                },
                child: Column(
                  children: [
                    Container( // Text Input
                      height: 45,
                      clipBehavior: Clip.hardEdge,
                      constraints: BoxConstraints(
                        minHeight: 45,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColor.LightBorder, width: 2),
                        borderRadius: selectKurs_focusnode.hasFocus ? BorderRadius.only(topLeft: Radius.circular(AppSizes.BorderRadiusNormal), topRight: Radius.circular(AppSizes.BorderRadiusNormal)) : BorderRadius.circular(AppSizes.BorderRadiusNormal)
                      ),
                      child: Center(
                        child: TextField(
                          controller: selectKurs_controller,
                          focusNode: selectKurs_focusnode,
                          onTap: () {
                            setState(() {
                              // searchKursListVisible = true;
                            });
                          },
                          cursorColor: AppColor.Font,
                          cursorRadius: Radius.circular(AppSizes.BorderRadiusNormal),
                          style: TextStyle(color: AppColor.Font),
                          decoration: InputDecoration(
                            hintText: 'Kursname',
                            hintStyle: TextStyle(
                              color: AppColor.FontUnfocused,
                              fontWeight: FontWeight.w400,
                            ),
                            fillColor: AppColor.backgroundLight,
                            filled: true,
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: AppColor.AccentBlue, width: 3),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: AppColor.AccentBlue, width: 3),
                            ),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectKurs_controller.text = '';
                                });
                              },
                              child: Padding(
                                padding: EdgeInsets.all(15),
                                child: SvgPicture.asset('assets/icons/removex.svg'),
                              )
                            )),
                        ),
                      ),
                    ),
                    selectKurs_focusnode.hasFocus ? Container( // Vorschläge für Textinput
                      height: searchKursList.length > 3 ? 3*45+45/2 : searchKursList.length*45,
                      // constraints: BoxConstraints(
                      //   maxHeight: 5*45,
                      //   minHeight: 45
                      // ),
                      decoration: BoxDecoration(
                        color: AppColor.backgroundLight,
                        border: Border.all(color: AppColor.LightBorder, width: 1),
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(AppSizes.BorderRadiusNormal), bottomRight: Radius.circular(AppSizes.BorderRadiusNormal))
                      ),
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: searchKursList.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedKursList.add(searchKursList[index]);
                                nonselectedKursList.remove(searchKursList[index]);
                                selectKurs_controller.text = '';
                              });
                            },
                            child: Container(
                              height: 45-8,
                              margin: EdgeInsets.all(4),
                              padding: EdgeInsets.only(left: 15),
                              alignment: Alignment.centerLeft,
                              decoration: BoxDecoration(
                                // border: Border.all(color: Colors.red, width: 1)
                              ),
                              child: Text(
                                searchKursList[index],
                                style: TextStyle(
                                  color: AppColor.Font
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ) : SizedBox(width: 0, height: 0,)
                  ],
                )
              ),
            ],
          ),
          SizedBox(height: 25,),
          Expanded( // Selected Kurs List
            child: Container(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSizes.BorderRadiusNormal)
              ),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: selectedKursList.length,
                itemBuilder: ((context, index) {
                  return Container(
                    height: 45,
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      border: index != selectedKursList.length-1 ? BorderDirectional(bottom: BorderSide(color: AppColor.LightBorder, width: 1)) : Border.all(color: AppColor.transparent)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          selectedKursList[index],
                          style: TextStyle(
                            color: AppColor.Font
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              nonselectedKursList.add(selectedKursList[index]);
                              selectedKursList.removeAt(index);
                            });
                          },
                          child: SvgPicture.asset('assets/icons/removex.svg'),
                        )
                        
                      ]
                    )
                  );
                }),
              ),
            ),
          )
        ],
      ),
    );
  }
}