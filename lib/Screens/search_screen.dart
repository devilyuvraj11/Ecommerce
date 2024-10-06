import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/consts/consts.dart';
import 'package:ecommerce/details/item_detail.dart';
import 'package:ecommerce/services/firestore_services.dart';
import 'package:ecommerce/widgets/loading_indiicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchScreen extends StatelessWidget{
  final String title;
  const SearchScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: title.text.color(darkFontGrey).make(),
      ),

      body: FutureBuilder(
          future: FirestoreServices.searchProduct(title),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
            if(!snapshot.hasData){
              return Center(child: loadingIndicator(),);
            }
            else if(snapshot.data!.docs.isEmpty){
              return "No Product Found".text.makeCentered();
            }
            else{
              var data = snapshot.data!.docs;
              var filtered = data.where((element) => element['p_name'].toString().toLowerCase().contains(title!.toLowerCase())).toList();

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisExtent: 200, crossAxisSpacing: 8, mainAxisSpacing: 8),
                    children: filtered.mapIndexed((currentValue, index) => Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [Image.network(filtered[index]['p_images'][0],width: 190, height: 130, fit: BoxFit.cover,),
                            "${filtered[index]['p_name']}".text.fontFamily(semibold).color(darkFontGrey).make(),
                            "${filtered[index]['p_price']}".text.color(redColor).fontFamily(bold).size(16).make(),
                            ]
                            ).box.white.outerShadowMd.rounded.margin(const EdgeInsets.symmetric(horizontal: 4)).rounded.padding(const EdgeInsets.all(12)).make()
                    .onTap(() {Get.to(() => ItemDetail(title: "${filtered[index]['p_name']}", data: filtered[index]));})
                    ).toList(),
                ),
              );
            }
          }),
    );
  }

}