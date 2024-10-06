import 'package:ecommerce/consts/consts.dart';
import 'package:flutter/cupertino.dart';

Widget orderPlaceDetails({required String title1, required String title2, required String d1, required String d2}){
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            title1.text.fontFamily(semibold).make(),
            "$d1".text.color(redColor).fontFamily(semibold).make(),
          ],
        ),
        SizedBox(
          width: 120,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              title2.text.fontFamily(semibold).make(),
              "$d2".text.make()
            ],
          ),
        )
      ],
    ),
  );
}