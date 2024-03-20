import 'package:flutter/material.dart';
import 'package:gbevplan/components/popUp.dart';
import 'package:gbevplan/theme/colors.dart';
import 'package:gbevplan/theme/sizes.dart';
import 'package:hive_flutter/adapters.dart';

class TimeTable extends StatefulWidget {
  const TimeTable({super.key});

  @override
  State<TimeTable> createState() => _TimeTableState();
}

class _TimeTableState extends State<TimeTable> with SingleTickerProviderStateMixin  {

  late AnimationController _controllerLoadingBar;

  void update() {
    _controllerLoadingBar.value = 0;
    _controllerLoadingBar.animateTo(1);
  }

  @override
  void initState() {
    _controllerLoadingBar = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
      value: 0
    );
    update();
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
    return GestureDetector(


        onVerticalDragStart: (details) {
          _startY = details.globalPosition.dy;
        },
        onVerticalDragUpdate: (details) {
          double currentY = details.globalPosition.dy;
          _deltaY = currentY - _startY;
        },
        onVerticalDragEnd: (details) {
          int? primvelocity = details.primaryVelocity?.toInt();
          print(primvelocity.toString() + ' | ' + _deltaY.toString());
          if (primvelocity == null) {return;}
          else if (primvelocity > 1000 && _deltaY > 200) {
            update();
          }
        },
        
        child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(4),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Expanded(
                  child: Container(
                  height: 1,
                  decoration: BoxDecoration(
                    color: AppColor.FontUnfocused
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
          ),
          Expanded(
            child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.green, width: 1)
                ),
              ),
            )
          
        ],
      ),
    );
  }
}