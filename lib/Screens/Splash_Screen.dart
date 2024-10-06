import 'dart:async';

import 'package:ecommerce/Screens/home.dart';
import 'package:ecommerce/Screens/login_Screen.dart';
import 'package:ecommerce/consts/consts.dart';
import 'package:ecommerce/consts/firebase_const.dart';
import 'package:ecommerce/widgets/app_logo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class splash_screen extends StatefulWidget{
  const splash_screen({super.key});

  @override
  State<StatefulWidget> createState() {
    return splashState();
  }
}

class splashState extends State<splash_screen>{

  changeScreen()async{
    Timer(const Duration(seconds: 3),(){
      auth.authStateChanges().listen((User? user){
        if(user == null && mounted){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const Login_Screen()));
        }
        else{
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Home()));
        }
      });
    });
  }

  @override
  void initState() {
    changeScreen();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: redColor,
      body: Center(
        child: Column(
          children: [
           Align(
               alignment: Alignment.topLeft,
               child: Image.asset(icSplashBg, width: 300,)),
            20.heightBox,
            applogoWidget(),
            10.heightBox,
            appname.text.fontFamily(bold).size(20).white.make(),
            5.heightBox,
            appversion.text.white.make(),
            const Spacer(),
            credits.text.white.fontFamily(semibold).make(),
          ],
        ),
      ),
    );
  }

}