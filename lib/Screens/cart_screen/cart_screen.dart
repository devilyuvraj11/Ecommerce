import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/Screens/cart_screen/shipping_screen.dart';
import 'package:ecommerce/consts/consts.dart';
import 'package:ecommerce/consts/firebase_const.dart';
import 'package:ecommerce/controller/cart_controller.dart';
import 'package:ecommerce/services/firestore_services.dart';
import 'package:ecommerce/widgets/custom_Button.dart';
import 'package:ecommerce/widgets/loading_indiicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Cart_Screen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return Cart_ScreenState();
  }
}

class Cart_ScreenState extends State<Cart_Screen>{
  @override
  Widget build(BuildContext context) {

    var controller = Get.put(CartController());
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: "Shopping Cart".text.color(darkFontGrey).fontFamily(semibold).make(),
      ),
      bottomNavigationBar:  SizedBox(
          height: 60,
          child: ElButton(color: redColor,onPress: (){
            Get.to(() => const ShippingDetail());
          }, title: "Proceed to shipping",textColor: whiteColor)),
      body: StreamBuilder(
        stream: FirestoreServices.getCart(currentUser!.uid),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: loadingIndicator(),
            );
          }
            else if(!snapshot.hasData || snapshot.data == null){
              return Center(
                child: "Cart is empty".text.color(darkFontGrey).make(),
              );
          }
          else{

            var data = snapshot.data!.docs;
            controller.calculate(data);
            controller.productSnapshot = data;

    if (data.isEmpty) {
    return Center(
    child: "Cart is empty!".text.color(darkFontGrey).make(),
    );}
    else{

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Expanded(child: ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (BuildContext context, int index){
                        return ListTile(
                          leading: Image.network('${data[index]['img']}', width: 80, fit: BoxFit.cover,),
                          title: "${data[index]['title']} (x ${data[index]['qty']})".text.fontFamily(semibold).size(16).make(),
                          subtitle: "${data[index]['tprice']}".numCurrency.text.fontFamily(semibold).color(redColor).size(14).make(),
                          trailing: const Icon(Icons.delete, color: redColor).onTap((){
                            FirestoreServices.deleteDocument(data[index].id);
                          })
                        );
                  })),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      "Total Price".text.fontFamily(semibold).color(darkFontGrey).make(),
                      Obx(() => "${controller.totalP}".numCurrency.text.fontFamily(semibold).color(redColor).make()),
                    ],
                  ).box.padding(const EdgeInsets.all(12)).width(context.screenWidth - 60).color(lightGolden).roundedSM.make(),
                  10.heightBox,
                  //SizedBox(width: context.screenWidth - 60, child: ElButton(color: redColor,onPress: (){}, title: "Proceed to shipping",textColor: whiteColor))
                ],
              ),
            );
          } }
        },
      )
    );
  }
}