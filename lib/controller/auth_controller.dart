import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/consts/consts.dart';
import 'package:ecommerce/consts/firebase_const.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';


class AuthController extends GetxController{
  var isloading = false.obs;
  //text Controller
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  //login method

  Future<UserCredential?> loginMethod({context}) async{
    UserCredential? userCredential;

    try{
      userCredential = await auth.signInWithEmailAndPassword(email: emailController.text, password: passwordController.text);
      User? user = userCredential.user;

      if (user != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

        if (userDoc.exists) {
          VxToast.show(context, msg: "User signed in: ${user.email}");
          return userCredential;
        } else {
          // User not found in Firestore, sign out and show error
          await FirebaseAuth.instance.signOut();
          VxToast.show(context, msg: 'User not found in user.');
          return null;
        }
      }
    }
    on FirebaseAuthException catch(e){
      if (e.code == 'user-not-found') {
        VxToast.show(context, msg: 'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        VxToast.show(context, msg: 'Wrong password provided.');
      }
    }catch (e){
      throw Exception(e.toString());
    }
    return null;
  }

  //signup method

  Future<UserCredential?> signupMethod({email, password, context}) async{
    UserCredential? userCredential;

    try{
      userCredential = await auth.createUserWithEmailAndPassword(email: email, password: password);
    }
    on FirebaseAuthException catch(e){
      VxToast.show(context, msg: e.toString());
    }
    return userCredential;
  }

  //storing data method

storeUserData({name, password, email}) async {
  DocumentReference store = firestore.collection(userCollection).doc(
      currentUser!.uid);
  store.set({
    'name': name,
    'password': password,
    'email': email,
    'imageUrl': '',
    'id': currentUser!.uid,
    'cart_count': "00",
    'wishlist_count': "00",
    'order_count': "00"
  });
}
    //signout merthod
    signoutMethod(context) async{
      try{
        isloading(true);
        await auth.signOut();
      }
      catch (e){
        VxToast.show(context, msg: e.toString());
      }
      finally{
        isloading(false);
      }
    }

}