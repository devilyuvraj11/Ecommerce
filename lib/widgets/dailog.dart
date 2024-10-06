import 'package:ecommerce/consts/consts.dart';
import 'package:ecommerce/widgets/custom_Button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget exitDailog(context){
  return Dialog(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        "Confirm".text.fontFamily(bold).color(darkFontGrey).size(18).make(),
        const Divider(),
        10.heightBox,
        "Are you sure want to exit?".text.fontFamily(bold).color(darkFontGrey).size(18).make(),
        10.heightBox,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElButton(color: redColor, onPress: (){
              SystemNavigator.pop();
            }, title: "Yes", textColor: whiteColor),
            ElButton(color: redColor, onPress: (){
              Navigator.pop(context);
            }, title: "No", textColor: whiteColor)
          ],
        )
      ],
    ).box.color(lightGrey).padding(const EdgeInsets.all(12)).rounded.make(),
  );
}