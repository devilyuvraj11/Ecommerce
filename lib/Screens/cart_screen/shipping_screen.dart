import 'package:ecommerce/Screens/cart_screen/payment_method.dart';
import 'package:ecommerce/consts/consts.dart';
import 'package:ecommerce/controller/cart_controller.dart';
import 'package:ecommerce/widgets/custom_Button.dart';
import 'package:ecommerce/widgets/custom_TextField.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShippingDetail extends StatelessWidget{
  const ShippingDetail({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<CartController>();
    return Scaffold(

      appBar: AppBar(
        title: "Shipping Info".text.fontFamily(semibold).color(darkFontGrey).make(),
      ),
      bottomNavigationBar: SizedBox(
          height: 60,
          child: ElButton(onPress: (){
            if(controller.addressController.text.length > 10 || controller.phoneController.text == 10){
              Get.to(() => const PaymentMethods());
            }else{
              VxToast.show(context, msg: "Please fill the form");
            }

          }, color: redColor, textColor: whiteColor, title: "Continue")),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            customTextField(hint: "Address", toHide: false, title: "Address", controller: controller.addressController),
            customTextField(hint: "City", toHide: false, title: "City", controller: controller.cityController),
            customTextField(hint: "State", toHide: false, title: "State", controller: controller.stateController),
            customTextField(hint: "Pin code", toHide: false, title: "Pin Code", controller: controller.pincodeController),
            customTextField(hint: "Phone", toHide: false, title: "Phone", controller: controller.phoneController)
          ],
        ),
      ),
    );
  }

}