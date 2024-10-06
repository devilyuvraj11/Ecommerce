import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/Screens/chat_screen/chat_screen.dart';
import 'package:ecommerce/consts/consts.dart';
import 'package:ecommerce/services/firestore_services.dart';
import 'package:ecommerce/widgets/loading_indiicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MessagingScreen extends StatelessWidget{
  const MessagingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: "My Messages".text.color(darkFontGrey).fontFamily(semibold).make(),
      ),
      body: StreamBuilder(stream: FirestoreServices.getAllMessages(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
            if(!snapshot.hasData){
              return Center(child: loadingIndicator(),);
            }
            else if(snapshot.data!.docs.isEmpty){
              return "No messages yet!".text.color(darkFontGrey).makeCentered();
            }
            else{
              var data = snapshot.data!.docs;
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Expanded(child: ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (BuildContext context, int index){
                          return Card(
                            child: ListTile(
                              onTap: (){
                                Get.to(() => const ChatScreen(), arguments: [data[index]['friendname'].toString(), data[index]['toId'].toString()]);
                              },
                              leading: const CircleAvatar(
                                backgroundColor: redColor,
                                child: Icon(Icons.person, color: whiteColor,),
                              ),
                              title: "${data[index]['friendname']}".text.fontFamily(semibold).color(darkFontGrey).make(),
                              subtitle: "${data[index]['last_msg']}".text.make(),
                            ),
                          );
                    }))
                  ],
                ),
              );
            }

          }),
    );
  }

}