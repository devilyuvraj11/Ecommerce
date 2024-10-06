import 'package:ecommerce/consts/consts.dart';
import 'package:ecommerce/details/category_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

Widget featuredButton({String? title, icon}){
  return Row(
    children: [
      Image.asset(icon, width: 40, fit: BoxFit.fill),
      10.widthBox,
      title!.text.fontFamily(semibold).color(darkFontGrey).make()
    ],
  ).box.width(200).margin(const EdgeInsets.symmetric(horizontal: 4)).white.padding(const EdgeInsets.all(4)).roundedSM.outerShadow.make()
  .onTap((){
    Get.to(() => CategoryDetails(title: title));
  });
}