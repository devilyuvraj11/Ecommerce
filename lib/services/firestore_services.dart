import 'package:ecommerce/consts/consts.dart';
import 'package:ecommerce/consts/firebase_const.dart';
import 'package:get/get.dart';

class FirestoreServices{
//get users data
  static getUser(uid){
    return firestore.collection(userCollection).where('id',isEqualTo: uid).snapshots();
}

//get products according to category

static getProducts(categories){
    return firestore.collection(productsCollection).where('p_category', isEqualTo: categories).snapshots();
}

//get cart

static getCart(uid){
    return firestore.collection(cartCollection).where('added_by', isEqualTo: uid).snapshots();
}

//delete document
static deleteDocument(docId){
    return firestore.collection(cartCollection).doc(docId).delete();
}

//get all chat messages
static getChatMessages(docId){
    return firestore.collection(chatsCollection).doc(docId).collection(messagesCollection).orderBy('created_on', descending: false).snapshots();
}

static getAllOrders(){
    return firestore.collection(ordersCollection).where('order_by', isEqualTo: currentUser!.uid).snapshots();
}

static getWishList(){
    return firestore.collection(productsCollection).where('p_wishlist', arrayContains: currentUser!.uid).snapshots();
}

static getAllMessages(){
    return firestore.collection(chatsCollection).where('fromId', isEqualTo: currentUser!.uid).snapshots();
}

static getCounts()async{
    var res = await Future.wait([
      firestore.collection(cartCollection).where('added_by', isEqualTo: currentUser!.uid).get().then((value){
       return value.docs.length;
      }),
      firestore.collection(productsCollection).where('p_wishlist', arrayContains: currentUser!.uid).get().then((value){
        return value.docs.length;
      }),
      firestore.collection(ordersCollection).where('order_by', isEqualTo: currentUser!.uid).get().then((value){
        return value.docs.length;
      })
    ]);
    return res;
}
static allproducts(){
  return firestore.collection(productsCollection).snapshots();
}

static getFeaturedProducts(){
    return firestore.collection(productsCollection).where('is_featured', isEqualTo: true).get();
}

static searchProduct(title){
    return firestore.collection(productsCollection).get();
}

static getSubCategoryProducts(title){
  return firestore.collection(productsCollection).where('p_subcategory', isEqualTo: title).snapshots();
}
}