import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom/contollers/order_controller.dart';
import 'package:ecom/models/order_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddressWidget extends StatelessWidget {

  User? user=FirebaseAuth.instance.currentUser;
  OrderController orderController=Get.put(OrderController());
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(stream: FirebaseFirestore.instance.collection('orders').doc(user!.uid).collection('confirmOrders').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Column(
              children: [

               ListTile(
                  leading: Image.asset('assets/illustrator/location_bg.png',),
                  title: Text('No address saved',maxLines: 2,),

                  trailing: Icon(Icons.check_box,color: Colors.green,),
                )
              ],
            );
          }
          final doc = snapshot.data!.docs.first;
          final address = doc['customerAddress'] ?? 'No address';

         return Column(
           children: [
             Obx(()=>ListTile(
               leading: Image.asset('assets/illustrator/location_bg.png',),
               title:
               orderController.saveAddress.value
                   ? Text('No address saved',maxLines: 2,)
                    : Text(address,maxLines: 2,),
               trailing: Icon(Icons.check_box,color: Colors.green,),
             ))
           ],
         );

  });
  }
}
