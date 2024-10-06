import 'dart:io';
import 'package:ecommerce/consts/consts.dart';
import 'package:ecommerce/controller/profile_Controller.dart';
import 'package:ecommerce/widgets/bg_data.dart';
import 'package:ecommerce/widgets/custom_Button.dart';
import 'package:ecommerce/widgets/custom_TextField.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditProfileScreen extends StatelessWidget{

  final dynamic data;

  const EditProfileScreen({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    var controller =  Get.find<ProfileController>();
    controller.nameController.text = data['name'];

    return bgWidget(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar:  AppBar(),
        body: Obx(() => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //if data image url and controller path is empty
               data['imageUrl'] == '' && controller.profileImgPath.isEmpty
              ? Image.asset(imgProfile, width: 100, fit: BoxFit.cover,).box.roundedFull.clip(Clip.antiAlias).make()
               // if data is not empty but controller path is empty
                 : data['imageUrl']!= '' && controller.profileImgPath.isEmpty
              ?Image.network(data['imageUrl'],width: 100,fit: BoxFit.cover).box.roundedFull.clip(Clip.antiAlias).make()

               // else if controller path is not empty but data image url is
                  :Image.file(File(controller.profileImgPath.value),
                  width: 100,
                  fit: BoxFit.cover).box.roundedFull.clip(Clip.antiAlias).make(),
              10.heightBox,
              ElButton(color: redColor,title: "Change", textColor: whiteColor, onPress: (){
               controller.changeImage(context);
              }),
              const Divider(),
              20.heightBox,
              customTextField(
                controller: controller.nameController,
                hint: nameHint,
                title: name,
                toHide: false,
              ),
              10.heightBox,
              customTextField(
                  controller: controller.oldpassController,
                  hint: passwordHint, title: oldpassword, toHide: true),
              10.heightBox,
              customTextField(
                  controller: controller.newpassController,
                  hint: passwordHint, title: newpassword, toHide: true),
              20.heightBox,
              controller.isloading.value ? const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(redColor),
              )
                  :SizedBox(
                  width: context.screenWidth - 60,
                  child: ElButton(title: "Save",
                      onPress: ()async{


                    controller.isloading(true);
                    //if image is not selected
                    if(controller.profileImgPath.value.isNotEmpty){
                      await controller.uploadProfileImage();
                    }else{
                      controller.profileImageLink = data['imageUrl'];
                    }
                    //if old password matches data base
                    if(data['password'] == controller.oldpassController.text) {
                      await controller.changeAuthPassword(
                        email: data['email'],
                        password: controller.oldpassController.text,
                        newpassword: controller.newpassController.text
                      );

                      await controller.updateProfile(
                          imgUrl: controller.profileImageLink,
                          name: controller.nameController.text,
                          password: controller.newpassController.text
                      );
                      VxToast.show(context, msg: "Updated");
                    }
                    else{
                      VxToast.show(context, msg: "Wrong old password");
                      controller.isloading(false);
                    }
                  }, textColor: whiteColor, color: redColor))
            ],
          ).box.white.shadowSm.padding(const EdgeInsets.all(16)).margin(const EdgeInsets.only(top: 50, left: 12, right: 12)).rounded.make(),
        ),
      ),
    );
  }

}