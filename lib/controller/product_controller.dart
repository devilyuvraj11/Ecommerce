import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/consts/consts.dart';
import 'package:ecommerce/consts/firebase_const.dart';
import 'package:ecommerce/model/category_model.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';

class ProductController extends GetxController{

  var quantity = 0.obs;
  RxInt colorIndex = 0.obs;
  var totalPrice = 0.obs;

  var isFav = false.obs;

  var subCat = [];

  getSubCategories(title) async{
    subCat.clear();
    var data = await rootBundle.loadString("lib/services/category_model.json");
    var decoded = categoryModelFromJson(data);
    var s = decoded.categories.where((element) => element.name == title).toList();

    for(var e in s[0].subcategory){
      subCat.add(e);
    }
  }

  changeColorIndex(index){
    colorIndex = index;
  }

  IncreaseQuantity(totalQuantity){
    if(quantity.value < totalQuantity) {
      quantity.value++;
    }
  }
  DecreaseQuantity(){
    if(quantity.value > 0) {
      quantity.value--;
    }
  }

  calculateTotalPrize(int price){
    totalPrice.value = price * quantity.value;
  }
  
  addToCart({title, img, sellername, color, qty, tprice, context, venderID})async{
    await firestore.collection(cartCollection).doc().set({
      'title': title,
      'img': img,
      'sellername': sellername,
      'color': color,
      'qty': qty,
      'vender_id': venderID,
      'tprice': tprice,
      'added_by': currentUser!.uid,
    }).catchError((error){
      VxToast.show(context, msg: error.toString());
    });
  }

  resetvalues(){
    totalPrice.value = 0;
    quantity.value = 0;
    colorIndex.value = 0;
  }

  addToWishList(docId, context) async{
    await firestore.collection(productsCollection).doc(docId).set({
      'p_wishlist': FieldValue.arrayUnion([currentUser!.uid])
    }, SetOptions(merge: true));
    isFav(true);
    VxToast.show(context, msg: "Added to WishList");
  }

  removeFromWishlist(docId, context) async{
    await firestore.collection(productsCollection).doc(docId).set({
      'p_wishlist': FieldValue.arrayRemove([currentUser!.uid])
    }, SetOptions(merge: true));

    isFav(false);

    VxToast.show(context, msg: "Remove from WishList");
  }

  checkIfFav(data) async{
    if(data['p_wishlist'].contains(currentUser!.uid)){
      isFav(true);
    }
    else{
      isFav(false);
    }
  }

}