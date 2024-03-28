
import 'package:flutter/material.dart';
import 'package:gbevplan/code/normTTCalc.dart';
import 'package:gbevplan/theme/colors.dart';
import 'package:gbevplan/theme/sizes.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class page_settings_changetimetable_weekday extends StatefulWidget {
  // const page_settings_changetimetable_weekday({super.key, required int weekday});
  const page_settings_changetimetable_weekday({Key? key, required this.weekday}) : super(key: key);

  final int weekday;

  @override
  State<page_settings_changetimetable_weekday> createState() => page_settings_changetimetable_weekdayState();
}

class page_settings_changetimetable_weekdayState extends State<page_settings_changetimetable_weekday> {
  
  // Hive - Storage
  Box userdata_box = Hive.box('userdata');
  Box appdata_box = Hive.box('appdata');
  Box apidata_box = Hive.box('apidata');

  late Map<int, Map<int, String>> normTT;

  @override
  void initState() {
    normTT = convertNormTTfromHiveDynMapToMap(appdata_box.get('normtimetable'));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder( // Hot reload changes on HIVE appdata changes (just to try it out I guess)
      valueListenable: appdata_box.listenable(),
      builder: ((context, value, _) {
        normTT = convertNormTTfromHiveDynMapToMap(value.get('normtimetable'));

        return Container(
          height: normTT[widget.weekday]!.entries.length*45,
          width: 300,
          child: ListView.builder(  
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsetsDirectional.all(0), // EdgeInsets.zero
            itemCount: normTT[widget.weekday]!.entries.length,
            
            itemBuilder: ((context, index) {
              String contentText = normTT[widget.weekday]![index+1].toString();
              return Container(
                height: 45,
                width: 300,
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.symmetric(horizontal: 50),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: normTT[widget.weekday]!.entries.length != index+1 ? AppColor.LightBorder : AppColor.transparent, width: 1))
                ),
                child: Row(
                  children: [
                    Container(
                      height: double.infinity,
                      width: 65,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border(right: BorderSide(color: AppColor.LightBorder, width: 1))
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Text(
                          (index+1).toString(),
                          style: TextStyle(color: AppColor.Font),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: Text(
                        contentText,
                        style: TextStyle(color: AppColor.Font),
                      ),
                    ),
                  ],
                )
              );
                })
              ),
        );

      })
    );
    

  }
}