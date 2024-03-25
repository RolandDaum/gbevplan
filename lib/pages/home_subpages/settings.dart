import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gbevplan/components/popUp.dart';
import 'package:gbevplan/dataobj/hive_metadata.dart';
import 'package:gbevplan/theme/colors.dart';
import 'package:gbevplan/theme/sizes.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/adapters.dart';

class page_Settings extends StatefulWidget {
  page_Settings({super.key});

  @override
  State<StatefulWidget> createState() {
    return page_SettingsState();
  }
}

class page_SettingsState extends State<page_Settings> {
  final Box<dynamic> hiveDataBox = Hive.box('data');

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding( // Title
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Text(
            'S E T T I N G S',
            style: TextStyle(
              color: AppColor.Font
            ),
          ),
        ),
        Container( // Seperating line
          width: 300,
          height: 1,
          decoration: BoxDecoration(
            color: AppColor.LightBorder
          ),
        ),
        Padding( // Change Timetable
          padding: const EdgeInsets.only(top: 20),
          child: GestureDetector(
            onTap: () {
              context.push('/settings_changetimetable');
            },
            child: Container(
              width: 250,
              height: 45,
              decoration: BoxDecoration(
                color: AppColor.backgroundLight,
                border: Border.all(color: AppColor.LightBorder, width: 1),
                borderRadius: BorderRadius.circular(AppSizes.BorderRadiusNormal)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SvgPicture.asset('assets/icons/editcalender.svg'),
                  ),
                  Text(
                    'change timetable',
                    style: TextStyle(
                      color: AppColor.Font
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        Padding( // Delete all Data
          padding: const EdgeInsets.only(top: 20),
          child: GestureDetector(
            onTap: () {
              hiveDataBox.put('metadata', null).then(
                (value) {
                  PopUp.create(context, 1, 'Success', 'removed all data');
                }
              ); // IDK catchError thing is weird
            },
            child: Container(
              width: 250,
              height: 45,
              decoration: BoxDecoration(
                color: AppColor.InfoRedBG,
                borderRadius: BorderRadius.circular(AppSizes.BorderRadiusNormal)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SvgPicture.asset('assets/icons/trashcanred.svg'),
                  ),
                  Text(
                    'Delete all data!',
                    style: TextStyle(
                      color: AppColor.Font
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
  
}