import 'package:ecommerce/consts/consts.dart';
import 'package:flutter/material.dart';

Widget customTextField({String? title, String? hint, toHide, controller}){
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      title!.text.color(redColor).fontFamily(semibold).size(16).make(),
      5.heightBox,
      TextFormField(
        controller: controller,
        obscureText: toHide,
        decoration: InputDecoration(
          isDense: true,
          //icon: iconData,
          hintStyle: const TextStyle(fontFamily: semibold, color: textfieldGrey),
          hintText: hint,
          fillColor: lightGrey,
          filled: true,
          border: InputBorder.none,
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: redColor
            )
          )
        ),
      ),
      5.heightBox,
    ],
  );
}