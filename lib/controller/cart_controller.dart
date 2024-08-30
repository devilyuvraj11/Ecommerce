import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/consts/firebase_const.dart';
import 'package:ecommerce/controller/home_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class CartController extends GetxController{
  var totalP = 0.obs;

  calculate(data) {
    totalP.value = 0;
    for (var i = 0; i < data.length; i++) {
      totalP.value = totalP.value + int.parse(data[i]['tprice'].toString());
    }
  }

  //Text controller fo shipping detail
  var addressController = TextEditingController();
  var cityController = TextEditingController();
  var stateController = TextEditingController();
  var pincodeController = TextEditingController();
  var phoneController = TextEditingController();

  var paymentIndex = 0.obs;

  late dynamic productSnapshot;
  var products = [];
  var vendors = [];

  var placingOrder = false.obs;

  changePaymentIndex(index){
    paymentIndex.value = index;
  }

  placeMyOrder({required orderPaymentMethod, required totalAmount})async{
    placingOrder(true);
    await getProductDetail();
    await firestore.collection(ordersCollection).doc().set({
      'order_code': "285123",
      'order_date': FieldValue.serverTimestamp(),
      'order_by': currentUser!.uid,
      'order_by_name': Get.find<HomeController>().username,
      'order_by_email': currentUser!.email,
      'order_by_address': addressController.text,
      'order_by_state': stateController.text,
      'order_by_city': cityController.text,
      'order_by_phone': phoneController.text,
      'order_by_pincode': pincodeController.text,
      'shipping_method': "Home Delivery",
      'payment_method': orderPaymentMethod,
      'order_placed': true,
      'order_confirmed': false,
      'order_delivered': false,
      'order_on_delivery': false,
      'total_amount': "$totalAmount",
      'orders': FieldValue.arrayUnion(products),
      'vendors':FieldValue.arrayUnion(vendors)

    });
    placingOrder(false);
  }

  getProductDetail(){
    products.clear();
    vendors.clear;
    for(var i = 0; i < productSnapshot.length; i++){
      products.add({
        'color': productSnapshot[i]['color'],
        'img': productSnapshot[i]['img'],
        'vendr_id': productSnapshot[i]['vender_id'],
        'tprice': productSnapshot[i]['tprice'],
        'qty': productSnapshot[i]['qty'],
        'title': productSnapshot[i]['title'],
      });
      vendors.add(productSnapshot[i]['vender_id']);
    }
  }

  clearCart(){
    for(var i = 0 ; i < productSnapshot.length; i++){
      firestore.collection(cartCollection).doc(productSnapshot[i].id).delete();
    }
  }
}