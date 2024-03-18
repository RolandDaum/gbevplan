import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gbevplan/theme/colors.dart';
import 'package:gbevplan/theme/sizes.dart';

class PopUp {
  static bool _isShowing = false;
  /**
   * BuildContext context
   * int importants (1 - Green, 2 - Yellow, 3 - Red, 0 - Normal/Info)
   * String Title - Title of the popUp
   * String Messag - Message of the popUp
   */
  static void create(BuildContext context, int importants, String Title, String Message) {
    if (_isShowing) {
      print('There is already a popup');
      return;
    }
    _isShowing = true;
    OverlayEntry? overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: 50,
        right: 50,
        bottom: 50,
        child: PopUpWidget(importants: importants, title: Title, message: Message, onClose: () {
          overlayEntry?.remove();
          _isShowing = false;
        }),
      ),
    );
    Overlay.of(context).insert(overlayEntry);
  }    
}

class PopUpWidget extends StatefulWidget {
  final int importants;
  final String title;
  final String message;
  final VoidCallback onClose;

  PopUpWidget({Key? key, required this.importants, required this.title, required this.message, required this.onClose}) : super(key: key);

  @override
  _PopUpWidgetState createState() => _PopUpWidgetState();
}

class _PopUpWidgetState extends State<PopUpWidget> {
  double opacity = 0;
  Color background = AppColor.backgroundLight;
  Color borderColor = Color.fromARGB(0, 0, 0, 0);
  String iconPath = 'assets/icons/popUp/';

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 1), () {
      setState(() {
        opacity = 1;
      });
    });
    switch (widget.importants) {
      case 1:
        background = AppColor.InfoGreenBG;
        iconPath += 'InfoGreen.svg';
        break;
      case 2:
        background = AppColor.InfoYellowBG;
        iconPath += 'InfoYellow.svg';
        break;
      case 3:
        background = AppColor.InfoRedBG;
        iconPath += 'InfoRed.svg';
        break;
      default:
        background = AppColor.backgroundLight;
        borderColor = AppColor.LightBorder;
        iconPath += 'InfoNormal.svg';
        break;
    }


    Future.delayed(Duration(milliseconds: 3500), () {
      setState(() {
        opacity = 0;
      });
      Future.delayed(Duration(milliseconds: 300), () {
        widget.onClose();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: opacity,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: Container(
        height: 45,
        decoration: BoxDecoration(
          color: background,
          border: Border.all(color: borderColor, width: 1),
          borderRadius: BorderRadius.circular(AppSizes.BorderRadiusNormal), // Adjust the border radius as needed
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [ 
                Padding(padding: EdgeInsets.all(10), child: SvgPicture.asset(iconPath),),
                Padding(padding: EdgeInsets.all(5), child: Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColor.Font,
                  ),
                ),),
                
                Padding(padding: EdgeInsets.all(10), child: Text(
                  widget.message, 
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                    color: AppColor.Font
                  ),
                  ),
                ),
              ],
            ),
            Padding(padding: EdgeInsets.all(10), child: GestureDetector(
              onTap: () {
                setState(() {
                  opacity = 0;
                });
                Future.delayed(Duration(milliseconds: 300), () {
                  widget.onClose();
                });
              },
              child: SvgPicture.asset('assets/icons/close.svg'),
            ),)
            
          ],
        ),
      ),
    );
  }  
}