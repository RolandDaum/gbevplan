import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gbevplan/theme//colors.dart';
import 'package:gbevplan/theme/sizes.dart';

class Login extends StatefulWidget {
  const Login({
    super.key,
  });


  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _obscureText_Password = true;
  bool _remeberme_state = false;

  @override
  Widget build(BuildContext context) {
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
                  SizedBox(height: 35,),
                  Container(
                    width: 150,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.AccentBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),

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
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container( 
                    width: 150,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _remeberme_state = !_remeberme_state;
                            });
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
                              padding: EdgeInsets.all(2.5),
                              child: _remeberme_state ? SvgPicture.asset('assets/icons/checkbox.svg') : Text(''),
                            ),
                          ),
                        ),
                        SizedBox(width: 10,),
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
                  )             
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Padding Textinput_Username() {
    return Padding(padding: const EdgeInsets.all(10), 
      child: Container(
        height: 45,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          border: Border.all(color: AppColor.LightBorder, width: 2),
          borderRadius: BorderRadius.circular(5)
        ),
        child: Center(
          child: TextField(
            cursorColor: AppColor.Font,
            cursorRadius: Radius.circular(5),
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
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          border: Border.all(color: AppColor.LightBorder, width: 2),
          borderRadius: BorderRadius.circular(5)
        ),
        child: Center(
          child: TextField(
            // onChanged: (value) {
            //   password = value;
            // },
            obscureText: _obscureText_Password,
            cursorColor: AppColor.Font,
            cursorRadius: const Radius.circular(5),
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
              )
              
              
              // IconButton(
              //   onPressed: () {
              //     setState(() {
              //       _obscureText_Password = !_obscureText_Password;
              //     });}, 
              //   icon: SvgPicture.asset('assets/icons/eye.svg')),
              ),
            ),
          ),
        ),
      );
  }
}
