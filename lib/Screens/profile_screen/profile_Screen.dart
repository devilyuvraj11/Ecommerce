import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/Screens/chat_screen/messaging_screen.dart';
import 'package:ecommerce/Screens/edit_profile_screen.dart';
import 'package:ecommerce/Screens/login_Screen.dart';
import 'package:ecommerce/Screens/profile_screen/orders_screen/orders_screen.dart';
import 'package:ecommerce/Screens/profile_screen/wishlist_screen/wishlist_screen.dart';
import 'package:ecommerce/consts/consts.dart';
import 'package:ecommerce/consts/firebase_const.dart';
import 'package:ecommerce/consts/lists.dart';
import 'package:ecommerce/controller/auth_controller.dart';
import 'package:ecommerce/controller/profile_Controller.dart';
import 'package:ecommerce/details/profile_components/detail_cards.dart';
import 'package:ecommerce/services/firestore_services.dart';
import 'package:ecommerce/widgets/bg_data.dart';
import 'package:ecommerce/widgets/loading_indiicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Profile_Screen extends StatelessWidget{

  const Profile_Screen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProfileController());
    return bgWidget(
      child: Scaffold(
        body: StreamBuilder(
            stream: FirestoreServices.getUser(currentUser!.uid),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if(!snapshot.hasData){
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(redColor),
                  ),);
                }
              else{

                var data = snapshot.data!.docs[0];


                return SafeArea(child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: const Align(alignment: Alignment.topRight, child: Icon(Icons.edit, color: whiteColor,),).onTap(() {
                        controller.nameController.text = data['name'];

                        Get.to(() => EditProfileScreen(data: data));
                      })
                    ),

                    Padding(padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      children: [
                        data['imageUrl'] == ''

                       ?Image.asset(imgProfile, width: 100, fit: BoxFit.cover,).box.roundedFull.clip(Clip.antiAlias).make()
                        :Image.network(data['imageUrl'], width: 100,fit: BoxFit.cover,).box.roundedFull.clip(Clip.antiAlias).make(),
                        10.heightBox,

                        Expanded(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            "${data['name']}".text.fontFamily(semibold).white.make(),
                            "${data['email']}".text.white.make(),
                          ],
                        )),
                        OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                color: whiteColor,
                              )),
                            onPressed: ()async{
                          await Get.put(AuthController()).signoutMethod(context).then((_) {
                            AuthController().isloading(false);
                          });
                          Get.offAll(() => Login_Screen());
                        }, child: logout.text.fontFamily(semibold).white.make())
                      ],
                    ),),
                    20.heightBox,

                    FutureBuilder(future: FirestoreServices.getCounts(),
                        builder: (BuildContext context, AsyncSnapshot snapshot){
                      if(!snapshot.hasData){
                        return Center(child: loadingIndicator());
                      }
                      else{
                        var countData = snapshot.data;
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          detailsCard(count: countData[0].toString(),title: "in your cart", width: context.screenWidth / 3.3),
                          detailsCard(count: countData[1].toString(), title: "in your wishlist", width: context.screenWidth/3.3),
                          detailsCard(count: countData[2].toString(),title: "your order", width: context.screenWidth/3.3),
                        ],
                      );}
                        }),


                    ListView.separated(
                        shrinkWrap: true,
                        separatorBuilder: (context, index){
                          return const Divider(color: lightGrey,);
                        }, itemCount: profileButtonsList.length,
                    itemBuilder: (BuildContext context, int index){
                          return ListTile(
                            onTap: (){
                              switch(index){
                                case 0:
                                  Get.to(() => const OrdersScreen());
                                  break;
                                case 1:
                                  Get.to(() => const WishlistScreen());
                                  break;
                                case 2:
                                  Get.to(() => const MessagingScreen());
                                  break;
                              }
                            },
                            leading: Image.asset(profileButtonsIcon[index],width: 22, color: darkFontGrey,),
                            title: profileButtonsList[index].text.fontFamily(semibold).color(darkFontGrey).make(),
                          );
                    }).box.white.rounded.margin(const EdgeInsets.all(12)).padding(const EdgeInsets.symmetric(horizontal: 16)).shadowSm.make().box.color(redColor).make()
                  ],
                ));
              }

        })
      ),
    );
  }
}