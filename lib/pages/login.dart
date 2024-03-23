import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gbevplan/components/popUp.dart';
import 'package:gbevplan/dataobj/hive_metadata.dart';
import 'package:gbevplan/pages/home.dart';
import 'package:gbevplan/theme//colors.dart';
import 'package:gbevplan/theme/sizes.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';

class Login extends StatefulWidget {
  const Login({super.key,});
  
  @override
  State<Login> createState() {
    return _LoginState();
  }
}

class _LoginState extends State<Login> {

  final Box<dynamic> hiveDataBox = Hive.box('data');

  bool _obscureText_Password = true;
  bool _remeberme_state = false;
  TextEditingController username_controller = new TextEditingController();
  TextEditingController password_controller = new TextEditingController();

  @override
  void initState() {
    super.initState();

    // Loading HIVE Data into State
    HIVE_Metadata hivemetadata = hiveDataBox.get('metadata');
    _remeberme_state = hivemetadata.appdata.uiinfo.rememberMe;
    username_controller.text = hivemetadata.secruecredentials.username;
    password_controller.text = hivemetadata.secruecredentials.password;
  }

  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: AppColor.transparent,
        systemNavigationBarColor: AppColor.backgroundDark
      )
    );

    return Scaffold(
      backgroundColor: AppColor.backgroundDark,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 115, left: 45, right: 45,),
          child: Column(
            children: [
              SvgPicture.asset('assets/Logo.svg', width: 150,),
              Column(
                children: [
                  const SizedBox(height: 70,),
                  Textinput_Username(),
                  TextInput_Password(),
                ]
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 35,),
                  LoginButton(),
                  const SizedBox(
                    height: 10,
                  ),
                  RememberMe()             
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  // Widgets
  Padding Textinput_Username() {
    return Padding(padding: const EdgeInsets.all(10), 
      child: Container(
        height: 45,
        width: 225,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          border: Border.all(color: AppColor.LightBorder, width: 2),
          borderRadius: BorderRadius.circular(AppSizes.BorderRadiusNormal)
        ),
        child: Center(
          child: TextField(
            controller: username_controller,
            cursorColor: AppColor.Font,
            cursorRadius: Radius.circular(AppSizes.BorderRadiusNormal),
            style: TextStyle(
              color: AppColor.Font
            ),
            decoration: InputDecoration(
              hintText: 'username',
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
            ),
          ),
        ),
      ),
    );
  }
  Padding TextInput_Password() {
    return Padding(
      padding: const EdgeInsets.all(10), 
      child: Container(
        height: 45,
        width: 225,
        clipBehavior: Clip.hardEdge,
        constraints: BoxConstraints(
          minHeight: 45,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: AppColor.LightBorder, width: 2),
          borderRadius: BorderRadius.circular(AppSizes.BorderRadiusNormal)
        ),
        child: Center(
          child: TextField(
            controller: password_controller,
            obscureText: _obscureText_Password,
            cursorColor: AppColor.Font,
            cursorRadius: Radius.circular(AppSizes.BorderRadiusNormal),
            style: TextStyle(
              color: AppColor.Font
            ),
            decoration: InputDecoration(
              hintText: 'password',
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
                    _obscureText_Password = !_obscureText_Password;
                  });
                },
                child: Padding(
                  padding: EdgeInsets.all(12.5),
                  child: SvgPicture.asset('assets/icons/eye.svg'),
                )
              )),
            ),
          ),
        ),
      );
  }
  Container LoginButton() {
    return Container(
      width: 150,
      child: ElevatedButton(
        onPressed: () {
          // PopUp.create(context, 3, "Info", "logged you out");
          if (_remeberme_state) {
            HIVE_Metadata hivemetadata = hiveDataBox.get('metadata');
              hivemetadata.secruecredentials.username = username_controller.text;
              hivemetadata.secruecredentials.password = password_controller.text;
              hiveDataBox.put('metadata', hivemetadata);
          } else {
            HIVE_Metadata hivemetadata = hiveDataBox.get('metadata');
              hivemetadata.secruecredentials.username = '';
              hivemetadata.secruecredentials.password = '';
              hiveDataBox.put('metadata', hivemetadata);
          }
          context.go('/timetable');
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.AccentBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.BorderRadiusSmall)
          ),
        ),
        child: Text(
          'Login',
          style: TextStyle(
            color: AppColor.FontSecondary,
            fontWeight: FontWeight.w400,
            fontSize: 17.5
          ),
        ),
      ),
    );
  }
  Container RememberMe() {
    return Container( 
      width: 150,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _remeberme_state = !_remeberme_state;
              });
              HIVE_Metadata hivemetadata = hiveDataBox.get('metadata');
              hivemetadata.appdata.uiinfo.rememberMe = _remeberme_state;
              hiveDataBox.put('metadata', hivemetadata);
            },
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                border: Border.all(color: AppColor.LightBorder, width: 1),
                borderRadius: BorderRadius.circular(AppSizes.BorderRadiusSmall),
                color: _remeberme_state ? AppColor.AccentBlue : AppColor.backgroundLight
              ),
              child: Padding(
                padding: const EdgeInsets.all(2.5),
                child: _remeberme_state ? SvgPicture.asset('assets/icons/checkbox.svg') : Text(''),
              ),
            ),
          ),
          const SizedBox(width: 10,),
          Text(
            'remember me',
            style: TextStyle(
              color: AppColor.Font,
              fontWeight: FontWeight.w300,
              fontSize: 15,
            ),
          )
        ],
      ),
    );
  }
}