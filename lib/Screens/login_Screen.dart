import 'package:ecommerce/Screens/home.dart';
import 'package:ecommerce/Screens/signup_Screen.dart';
import 'package:ecommerce/consts/consts.dart';
import 'package:ecommerce/consts/lists.dart';
import 'package:ecommerce/controller/auth_controller.dart';
import 'package:ecommerce/widgets/bg_data.dart';
import 'package:ecommerce/widgets/custom_Button.dart';
import 'package:ecommerce/widgets/custom_TextField.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/app_logo.dart';

class Login_Screen extends StatelessWidget{
  const Login_Screen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(AuthController());
  return bgWidget(
       child: Scaffold(
         resizeToAvoidBottomInset: false,
        body: Center(
          child: Column(
            children: [
              (context.screenHeight * 0.1).heightBox,
              applogoWidget(),
              10.heightBox,
              "LogIn to $appname".text.fontFamily(bold).white.size(18).make(),
              15.heightBox,
              Obx(() =>
                Column(
                  children: [
                    customTextField(hint: emailHint, title: email,toHide: false, controller: controller.emailController),

                    customTextField(hint: passwordHint, title: password, toHide: true, controller: controller.passwordController),
                    Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(onPressed: (){},
                            child: const Text(forgetpassword))),

                    5.heightBox,

                    controller.isloading.value? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(redColor),
                    )
                        : ElButton(onPress: ()async{
                      controller.isloading(true);
                      await controller.loginMethod(context: context).then((value){
                        if(value != null){
                         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home(),));
                        }else{
                          controller.isloading(false);
                        }
                      });
                    }, textColor: whiteColor, color: redColor,title: login).box.width(context.screenWidth - 50).make(),
                    5.heightBox,
                    createNewAccount.text.color(fontGrey).make(),
                    ElButton(title: signup, color: whiteColor,textColor: redColor,onPress: (){
                     Get.to(() => const Signup_Screen());
                    }).box.width(context.screenWidth - 50).make(),
                    10.heightBox,
                    loginWith.text.color(fontGrey).make(),
                    5.heightBox,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(3, (index) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          radius: 25,
                          backgroundColor: lightGrey,
                          child: Image.asset(socialIconList[index],
                          width: 30,),
                        ),
                      )),
                    )
                  ],
                ).box.white.rounded.padding(const EdgeInsets.all(16)).width(context.screenWidth - 70).shadowSm.make(),
              )
            ],
          ),
        ),
      ));
  }

}
