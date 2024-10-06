import 'package:ecommerce/consts/consts.dart';
import 'package:ecommerce/consts/lists.dart';
import 'package:ecommerce/controller/product_controller.dart';
import 'package:ecommerce/details/category_details.dart';
import 'package:ecommerce/widgets/bg_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class Category_Screen extends StatefulWidget{
  const Category_Screen({super.key});

  @override
  State<StatefulWidget> createState() {
    return Category_ScreenState();
  }
}

class Category_ScreenState extends State<Category_Screen>{
  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProductController());
   return bgWidget(
       child: Scaffold(
         appBar: AppBar(
          title: categories.text.fontFamily(bold).white.make(),
         ),
         body: Container(
           padding: const EdgeInsets.all(12),
           child: GridView.builder(
               shrinkWrap: true,
               itemCount: 9,
               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 8, crossAxisSpacing: 8, mainAxisExtent: 200), itemBuilder: (context, index){
             return Column(
               children: [
                 Image.asset(categoriesImages[index], height: 120, width: 190, fit: BoxFit.cover,),
                 10.heightBox,
                 categoriesList[index].text.color(darkFontGrey).align(TextAlign.center).make()
               ],
             ).box.white.rounded.clip(Clip.antiAlias).outerShadowSm.make().onTap(() {
               controller.getSubCategories(categoriesList[index]);
               Navigator.push(context, MaterialPageRoute(builder: (context)=> CategoryDetails(title: categoriesList[index])));
           });}),
         ),
       ));
  }
}