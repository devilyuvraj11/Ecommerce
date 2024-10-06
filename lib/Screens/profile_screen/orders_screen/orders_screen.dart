import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/Screens/profile_screen/orders_screen/orders_deatail.dart';
import 'package:ecommerce/consts/consts.dart';
import 'package:ecommerce/services/firestore_services.dart';
import 'package:ecommerce/widgets/loading_indiicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: "My Orders".text.color(darkFontGrey).fontFamily(semibold).make(),
      ),
      body: StreamBuilder(
        stream: FirestoreServices.getAllOrders(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: loadingIndicator(),
            );
          } else if (snapshot.data!.docs.isEmpty) {
            return "No orders yet!".text.color(darkFontGrey).makeCentered();
          } else {
            var data = snapshot.data!.docs;
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {
                var orderData = data[index].data() as Map<String, dynamic>;
                return ListTile(
                  leading: "${index + 1}".text.fontFamily(bold).color(darkFontGrey).xl.make(),
                  title: orderData['order_code'].toString().text.color(redColor).fontFamily(semibold).make(),
                  subtitle: orderData['total_amount'].toString().numCurrency.text.fontFamily(bold).make(),
                  trailing: IconButton(
                    onPressed: () {
                      Get.to(() => OrdersDeatail(data: orderData));
                    },
                    icon: const Icon(Icons.arrow_forward_ios_rounded, color: darkFontGrey),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
