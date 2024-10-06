
import 'package:ecommerce/Screens/home.dart';
import 'package:ecommerce/consts/consts.dart';
import 'package:ecommerce/consts/firebase_const.dart';
import 'package:ecommerce/controller/auth_controller.dart';
import 'package:ecommerce/widgets/bg_data.dart';
import 'package:ecommerce/widgets/custom_Button.dart';
import 'package:ecommerce/widgets/custom_TextField.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/app_logo.dart';

class Signup_Screen extends StatefulWidget{
  const Signup_Screen({super.key});

  @override
  State<Signup_Screen> createState() => _Signup_ScreenState();
}

class _Signup_ScreenState extends State<Signup_Screen> {

  bool? check = false;
  var controller = Get.put(AuthController());
  //text controller
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var repasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return bgWidget(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Center(
            child: Column(
              children: [
                (context.screenHeight * 0.1).heightBox,
                applogoWidget(),
                10.heightBox,
                "Join the $appname".text.fontFamily(bold).white.size(18).make(),
                15.heightBox,
                Obx(() => Column(
                    children: [
                      customTextField(hint: nameHint, title: name, controller: nameController,toHide: false),
                      customTextField(hint: emailHint, title: email, controller: emailController, toHide: false),
                      customTextField(hint: passwordHint, title: password, controller: passwordController, toHide: true),
                      customTextField(hint: passwordHint, title: retypePassword, controller: repasswordController, toHide: true),
                     15.heightBox,
                     Row(
                       children: [
                         Checkbox(checkColor: redColor,value: check, onChanged: (newValue){
                           setState(() {
                             check = newValue;
                           });
                         },),
                         10.widthBox,
                         Expanded(
                           child: RichText(text: const TextSpan(
                             children: [
                               TextSpan(text: "I agree to the ", style: TextStyle(
                                 fontFamily: bold,color: fontGrey
                               )),
                               TextSpan(text: terms,style: TextStyle(fontFamily: bold, color: redColor)),
                               TextSpan(text: " & ",style: TextStyle(fontFamily: bold, color: fontGrey)),
                               TextSpan(text: privacypolicy,style: TextStyle(fontFamily: bold, color: redColor)),
                             ]
                           )),
                         )
                       ],
                     ),
                      5.heightBox,
                      controller.isloading.value? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(redColor),):
                      ElButton(
                          onPress: ()async{
                       if(check != false){
                         controller.isloading(true);
                         try{
                           await controller.signupMethod(email: emailController.text, password: passwordController.text, context: context).then((value){
                            return controller.storeUserData(
                              email: emailController.text,
                              password: passwordController.text,
                              name: nameController.text,
                            );
                           }).then((value){
                             VxToast.show(context, msg: loggedin);
                             Get.offAll(()=> Home());
                           });
                         }catch(e){
                           auth.signOut();
                          VxToast.show(context, msg: e.toString());
                          controller.isloading(false);
                         }
                       }
                      },
                          textColor: whiteColor, color: check == true? redColor: lightGrey,title: signup)
                          .box.width(context.screenWidth - 50).make(),
                      10.heightBox,
                      RichText(text: const TextSpan(
                          children: [
                            TextSpan(text: alreadyhave, style: TextStyle(fontFamily: bold, color: fontGrey)),
                            TextSpan(text: login, style: TextStyle(fontFamily: bold, color: redColor)),
                          ]
                      )).onTap(() {Navigator.pop(context);})
                    ],
                  ).box.white.rounded.padding(const EdgeInsets.all(16)).width(context.screenWidth - 70).shadowSm.make(),
                )
              ],
            ),
          ),
        ));
  }
}