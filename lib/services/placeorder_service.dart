import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom/models/order_model.dart';
import 'package:ecom/screens/user-panel/confirm_order_screen.dart';
import 'package:ecom/services/orderid_generator_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

void placeOrder(
    {
      required BuildContext context,
      required String customerName,
      required String customerPhone,
      required String customerAddress,
      required String customerDeviceToken,})async
{

final user=FirebaseAuth.instance.currentUser;
EasyLoading.show(status: 'Please Wait..');

if(user!=null){
  try{
    QuerySnapshot querySnapshot=await FirebaseFirestore.instance.collection('cart').doc(user.uid).collection('cartOrders').get();

    List<QueryDocumentSnapshot> documents=querySnapshot.docs;

    for(var doc in documents){
      Map<String,dynamic> data=doc.data() as Map<String,dynamic>;

      String orderId=generateOrderId();

      OrderModel orderModel=OrderModel(
          productId: data['productId'],
          categoryId: data['categoryId'],
          productName: data['productName'],
          categoryName: data['categoryName'],
          salePrice: data['salePrice'],
          fullPrice: data['fullPrice'],
          productImages: data['productImages'],
          deliveryTime: data['deliveryTime'],
          isSale: data['isSale'],
          size: data['size'],
          productDescription: data['productDescription'],
          createdAt: data['createdAt'],
          updatedAt: data['updatedAt'],
          productQuantity: data['productQuantity'],
          productTotalPrice: data['productTotalPrice'],
          customerId: user.uid,
          status: false,
          customerName: customerName,
          customerPhone: customerPhone,
          customerAddress: customerAddress,
          customerDeviceToken: customerDeviceToken);

      for(var x=0;x<documents.length;x++){
          await FirebaseFirestore.instance.collection('orders').doc(user.uid).set({
            'uId':user.uid,
            'customerName':customerName,
            'customerPhone':customerPhone,
            'customerAddress':customerAddress,
            'customerDeviceToken':customerDeviceToken,
            'orderStatus':false,
            'createdAt':DateTime.now(),
          });

          //upload orders
          await FirebaseFirestore.instance.collection('orders').doc(user.uid).collection('confirmOrders').doc(orderId).set(orderModel.toMap());
        
          //delete cart  products
        await FirebaseFirestore.instance.collection('cart').doc(user.uid).
        collection('cartOrders').doc(orderModel.productId.toString()).delete().then((value){
          print('Delete cart products ${orderModel.productId.toString()}');
        });
      }
    }

    EasyLoading.dismiss();
    Get.offAll(()=>ConfirmOrderScreen());

  }catch(e){
    print('Error $e');
  }
}
}