import 'package:ecommerce/Screens/home.dart';
import 'package:ecommerce/consts/consts.dart';
import 'package:ecommerce/consts/lists.dart';
import 'package:ecommerce/controller/cart_controller.dart';
import 'package:ecommerce/widgets/custom_Button.dart';
import 'package:ecommerce/widgets/loading_indiicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentMethods extends StatelessWidget {
  const PaymentMethods({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<CartController>();

    return Obx(
          () => Scaffold(
        backgroundColor: whiteColor,
        bottomNavigationBar: SizedBox(
          height: 60,
          child: controller.placingOrder.value
              ? Center(
            child: loadingIndicator(),
          )
              : ElButton(
            onPress: () async {
              try {
                await controller.placeMyOrder(
                  orderPaymentMethod: paymentMethodsList[controller.paymentIndex.value],
                  totalAmount: controller.totalP.value,
                );
                await controller.clearCart();
                VxToast.show(context, msg: "Order Placed successfully");
                Get.offAll(() => Home());
              } catch (e) {
                VxToast.show(context, msg: "Failed to place order: $e");
              }
            },
            color: redColor,
            textColor: whiteColor,
            title: "Place Order",
          ),
        ),
        appBar: AppBar(
          title: "Choose Payment Method".text.fontFamily(semibold).color(darkFontGrey).make(),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Obx(
                () => Column(
              children: List.generate(paymentMethodsImg.length, (index) {
                return GestureDetector(
                  onTap: () {
                    controller.changePaymentIndex(index);
                  },
                  child: Container(
                    clipBehavior: Clip.antiAlias,
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: controller.paymentIndex.value == index ? redColor : Colors.transparent,
                        width: 3,
                      ),
                    ),
                    child: Stack(
                      alignment: Alignment.topRight,
                      children: [
                        Image.asset(
                          paymentMethodsImg[index],
                          width: double.infinity,
                          height: 100,
                          fit: BoxFit.cover,
                          colorBlendMode: controller.paymentIndex.value == index ? BlendMode.darken : BlendMode.color,
                          color: controller.paymentIndex.value == index ? Colors.black.withOpacity(0.3) : Colors.transparent,
                        ),
                        controller.paymentIndex.value == index
                            ? Transform.scale(
                          scale: 1.3,
                          child: Checkbox(
                            activeColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            value: true,
                            onChanged: (value) {},
                          ),
                        )
                            : Container(),
                        Positioned(
                          bottom: 10,
                          right: 10,
                          child: paymentMethodsList[index].text.white.fontFamily(semibold).size(16).make(),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
