import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/Screens/search_screen.dart';
import 'package:ecommerce/consts/consts.dart';
import 'package:ecommerce/consts/lists.dart';
import 'package:ecommerce/controller/home_controller.dart';
import 'package:ecommerce/controller/product_controller.dart';
import 'package:ecommerce/details/item_detail.dart';
import 'package:ecommerce/services/firestore_services.dart';
import 'package:ecommerce/widgets/featured_button.dart';
import 'package:ecommerce/widgets/home_button.dart';
import 'package:ecommerce/widgets/loading_indiicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Home_Screen extends StatelessWidget{
  const Home_Screen({super.key});

  @override
  Widget build(BuildContext context) {
    var textController = Get.find<HomeController>();
    var controller = Get.put(ProductController());
  return Container(
    padding: const EdgeInsets.all(12),
    color: lightGrey,
    width: context.screenWidth,
    height: context.screenHeight,
    child: SafeArea(
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            height: 60,
            color: lightGrey,
            child: TextFormField(
              controller: textController.searchController,
              decoration: InputDecoration(
                border: InputBorder.none,
                filled: true,
                suffixIcon: const Icon(Icons.search).onTap((){
                  if(textController.searchController.text.isNotEmptyAndNotNull) {
                    Get.to(() => SearchScreen(title: textController.searchController.text,));
                  }
                }),
                fillColor: whiteColor,
                hintText: searchitem,
                hintStyle: const TextStyle(color: textfieldGrey)
              ),
            ),
          ),
        10.heightBox,
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  VxSwiper.builder(
                      aspectRatio: 16/9,
                      autoPlay: true,
                      height: 200,
                      itemCount: sliderList.length,
                      itemBuilder: (context, index){
                        return Image.asset(
                          sliderList[index],
                          fit: BoxFit.fill,).box.rounded.clip(Clip.antiAlias).margin(const EdgeInsets.symmetric(horizontal: 10)).make();
                      }),
                  10.heightBox,
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children:
                      List.generate(2, (index) => home_Button(
                          height: context.screenHeight * 0.15,
                          width: context.screenWidth / 2.5,
                          icon: index == 0? icTodaysDeal: icFlashDeal,
                          title: index == 0? todayDeal: flashsale
                      ))
                  ),
                  10.heightBox,
                  VxSwiper.builder(
                      aspectRatio: 16/9,
                      autoPlay: true,
                      height: 200,
                      itemCount: secondsliderList.length,
                      itemBuilder: (context, index){
                        return Image.asset(
                          secondsliderList[index],
                          fit: BoxFit.fill,).box.rounded.clip(Clip.antiAlias).margin(const EdgeInsets.symmetric(horizontal: 10)).make();
                      }),
                  10.heightBox,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(3, (index) => home_Button(
                      height: context.screenHeight * 0.15,
                      width: context.screenWidth/3.5,
                      icon: index == 0? icTopCategories: index == 1 ? icBrands: icTopSeller,
                      title: index == 0? topCategories : index == 1 ? brand: topSalles,
                    )),
                  ),
                  20.heightBox,
                  Align(
                      alignment: Alignment.centerLeft,
                      child: featuredCategories.text.color(darkFontGrey).size(18).fontFamily(semibold).make()),
                  20.heightBox,
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(3, (index) => Column(
                          children: [
                            featuredButton(icon: featuredImages1[index], title: featuredTitles1[index]),
                            10.heightBox,
                            featuredButton(icon: featuredImages2[index], title: featuredTitles2[index]),
                          ],
                        )),
                    ),
                  ),
                  20.heightBox,

                  Container(
                    padding: const EdgeInsets.all(12),
                    width: double.infinity,
                    decoration: const BoxDecoration(color: redColor),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        featuredProduct.text.white.fontFamily(bold).size(18).make(),
                        10.heightBox,
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: FutureBuilder(
                            future: FirestoreServices.getFeaturedProducts(),
                            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                              if(!snapshot.hasData){
                                return Center(
                                  child: loadingIndicator(),
                                );
                              }
                              else if(snapshot.data!.docs.isEmpty){
                                return "No featured product".text.white.makeCentered();
                              }
                              else {

                                var featuedData = snapshot.data!.docs;
                                return Row(
                                  children: List.generate(featuedData.length, (index) =>
                                      Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Image.network(featuedData[index]['p_images'][0], width: 150, height: 130,
                                              fit: BoxFit.cover,),
                                            10.heightBox,
                                            "${featuedData[index]['p_name']}".text.fontFamily(
                                                semibold)
                                                .color(darkFontGrey)
                                                .make(),
                                            10.heightBox,
                                            "${featuedData[index]['p_price']}".text.color(redColor)
                                                .fontFamily(bold).size(16)
                                                .make()
                                          ]
                                      ).box.white.rounded
                                          .margin(const EdgeInsets.symmetric(
                                          horizontal: 4))
                                          .rounded
                                          .padding(const EdgeInsets.all(8))
                                          .make().onTap((){
                                        controller.checkIfFav(featuedData[index]);
                                        Get.to(() =>
                                            ItemDetail(title: "${featuedData[index]['p_name']}", data: featuedData[index],));
                                      })),
                                );
                              }
                            }
                          ),
                        )
                      ],
                    ),
                  ),

                  VxSwiper.builder(
                      aspectRatio: 16/9,
                      autoPlay: true,
                      height: 200,
                      itemCount: sliderList.length,
                      itemBuilder: (context, index){
                        return Image.asset(
                          sliderList[index],
                          fit: BoxFit.fill,).box.rounded.clip(Clip.antiAlias).margin(const EdgeInsets.symmetric(horizontal: 10)).make();
                      }),

                  20.heightBox,
                 StreamBuilder(stream: FirestoreServices.allproducts(),
                     builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                   if(!snapshot.hasData){
                     return loadingIndicator();
                   }
                   else{
                     var allproductsdata = snapshot.data!.docs;
                    return GridView.builder(
                         physics: const NeverScrollableScrollPhysics(),
                         shrinkWrap: true,
                         itemCount: allproductsdata.length,
                         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 8, crossAxisSpacing: 8, mainAxisExtent: 200), itemBuilder: (context, index){
                       return Column(
                           crossAxisAlignment: CrossAxisAlignment.center,
                           children: [Image.network(allproductsdata[index]['p_images'][0],width: 190, height: 130, fit: BoxFit.cover,),
                             "${allproductsdata[index]['p_name']}".text.fontFamily(semibold).color(darkFontGrey).make(),
                             "${allproductsdata[index]['p_price']}".text.color(redColor).fontFamily(bold).size(16).make(),
                           ]
                       ).box.white.rounded.margin(const EdgeInsets.symmetric(horizontal: 4)).rounded.padding(const EdgeInsets.all(12)).make().onTap((){
                         controller.checkIfFav(allproductsdata[index]);
                         Get.to(() =>
                             ItemDetail(title: "${allproductsdata[index]['p_name']}", data: allproductsdata[index],));
                       });
                     });
                   }
                     })
                ],
              ),
            ),
          )
        ],
      ),
    ),
  );
  }
}