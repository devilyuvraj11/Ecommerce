import 'package:ecommerce/Screens/Category_Screen.dart';
import 'package:ecommerce/Screens/cart_screen/cart_screen.dart';
import 'package:ecommerce/Screens/home_Screen.dart';
import 'package:ecommerce/Screens/profile_screen/profile_Screen.dart';
import 'package:ecommerce/consts/consts.dart';
import 'package:ecommerce/controller/home_controller.dart';
import 'package:ecommerce/widgets/dailog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Home extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<Home>{

  var controller = Get.put(HomeController());
  var navBarItem =[
    BottomNavigationBarItem(icon: Image.asset(icHome, width: 26,), label: home),
    BottomNavigationBarItem(icon: Image.asset(icCategories, width: 26,), label: categories),
    BottomNavigationBarItem(icon: Image.asset(icCart, width: 26,), label: cart),
    BottomNavigationBarItem(icon: Image.asset(icProfile, width: 26,), label: account),
  ];

  var navBody = [
    const Home_Screen(),
    const Category_Screen(),
    Cart_Screen(),
    Profile_Screen()
  ];
  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) async{
        showDialog(context: context, builder: (context) => exitDailog(context));
      },
        child: Scaffold(
          body: Column(
            children: [
              Obx(()=> Expanded(child: navBody.elementAt(controller.currentNavIndex.value),)),
            ],
          ),
          bottomNavigationBar: Obx(()=>
            BottomNavigationBar(
              currentIndex: controller.currentNavIndex.value,
              selectedItemColor: redColor,
              selectedLabelStyle: const TextStyle(fontFamily: semibold),
              type: BottomNavigationBarType.fixed,
              backgroundColor: whiteColor,
              onTap: (value){
                controller.currentNavIndex.value = value;
              },
              items: navBarItem,),
          ),
        ),
      );
  }

}