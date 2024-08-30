import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/consts/consts.dart';
import 'package:ecommerce/controller/product_controller.dart';
import 'package:ecommerce/details/item_detail.dart';
import 'package:ecommerce/services/firestore_services.dart';
import 'package:ecommerce/widgets/bg_data.dart';
import 'package:ecommerce/widgets/loading_indiicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class CategoryDetails extends StatefulWidget{
  final String? title;
  const CategoryDetails({super.key, required this.title});

  @override
  State<CategoryDetails> createState() => _CategoryDetailsState();
}

class _CategoryDetailsState extends State<CategoryDetails> {

  @override
  void initState() {
    super.initState();
    switchCategory(widget.title);
  }
  switchCategory(title){
    if(controller.subCat.contains(title)){
      productMethod = FirestoreServices.getSubCategoryProducts(title);
    }
    else{
      productMethod = FirestoreServices.getProducts(title);
    }
  }

  var controller = Get.find<ProductController>();
  dynamic productMethod;
  @override
  Widget build(BuildContext context) {

  return bgWidget(
    child: Scaffold(
      appBar: AppBar(
        title: widget.title!.text.fontFamily(bold).make(),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(controller.subCat.length, (index) =>
                  "${controller.subCat[index]}"
                      .text.size(12).fontFamily(semibold).color(darkFontGrey).makeCentered().box.white.rounded.size(120, 60).margin(const EdgeInsets.symmetric(horizontal: 4)).make().onTap((){
                        switchCategory("${controller.subCat[index]}");
                        setState(() {

                        });
                  })),
            ),
          ),
          20.heightBox,
          StreamBuilder(
              stream: productMethod,
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){

               if(snapshot.connectionState == ConnectionState.waiting){
                 return Expanded(
                   child: Center(
                     child: loadingIndicator(),
                   ),
                 );
               }

                else if(!snapshot.hasData || snapshot.data == null){
                 return Expanded(
                   child: "No product found!".text.color(darkFontGrey).makeCentered(),
                 );
               }


               else{

                 var data = snapshot.data!.docs;

              if (data.isEmpty) {
              return Expanded(
              child: "No product found!".text.color(darkFontGrey).makeCentered(),
              );}
              else{
                var data = snapshot.data!.docs;
                 return Expanded(
                           child: GridView.builder(
                               physics: const BouncingScrollPhysics(),
                               shrinkWrap: true,
                               itemCount: data.length,
                               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisExtent: 250, mainAxisSpacing: 8, crossAxisSpacing: 8),

                               itemBuilder: (context, index){
                                 return Column(
                                     crossAxisAlignment: CrossAxisAlignment.center,
                                     children: [
                                       Image.network(data[index]['p_images'][0],width: 190, height: 130, fit: BoxFit.cover,),
                                       "${data[index]['p_name']}".text.fontFamily(semibold).color(darkFontGrey).make(),
                                       "${data[index]['p_price']}".numCurrency.text.color(redColor).fontFamily(bold).size(16).make(),
                                     ]
                                 ).box.white.rounded.margin( const EdgeInsets.symmetric(horizontal: 4)).rounded.outerShadowSm.padding(const EdgeInsets.all(12))
                                     .make().onTap(() {
                                       controller.checkIfFav(data[index]);
                                       Get.to(() => ItemDetail(title: "${data[index]['p_name']}", data: data[index],));
                                 });
                               })
                       );
               }
              }}),
        ],
      )
    )

  );
}
}