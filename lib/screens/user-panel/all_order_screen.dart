import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom/contollers/cart_price_controller.dart';
import 'package:ecom/models/cart_model.dart';
import 'package:ecom/models/order_model.dart';
import 'package:ecom/models/product_model.dart';
import 'package:ecom/screens/user-panel/checkout_screen.dart';
import 'package:ecom/screens/user-panel/product_detail.dart';
import 'package:ecom/utils/constants/app_constraint.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:get/get.dart';
import 'package:image_card/image_card.dart';

import 'add_review_screen.dart';

class AllOrderScreen extends StatelessWidget {

  User? user=FirebaseAuth.instance.currentUser;

  final CartPriceController cartPriceController=Get.put(CartPriceController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstant.appMainColor,
        title: Text('All Orders',style: TextStyle(color: AppConstant.appTextColor),),
        iconTheme: IconThemeData(color: AppConstant.appTextColor),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('orders').doc(user!.uid).collection('confirmOrders').snapshots(),
        builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot) {
          if(snapshot.hasError){
            return Center(child: Text('Error'),);
          }
          if(snapshot.connectionState==ConnectionState.waiting){
            return Container(
              height: Get.height/5,
              child: Center(child: CupertinoActivityIndicator(),),
            );
          }
          if(snapshot.data!.docs.isEmpty){
            return Center(child: Text('No Products found'),);
          }
          if(snapshot.data!=null){
            return
              Container(
                  child:ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      final orderData=snapshot.data!.docs[index];

                      OrderModel orderModel=OrderModel(
                          productId: orderData['productId'],
                          categoryId: orderData['categoryId'],
                          productName: orderData['productName'],
                          categoryName: orderData['categoryName'],
                          salePrice: orderData['salePrice'],
                          fullPrice: orderData['fullPrice'],
                          productImages: orderData['productImages'],
                          deliveryTime: orderData['deliveryTime'],
                          isSale: orderData['isSale'],
                          productDescription: orderData['productDescription'],
                          createdAt: orderData['createdAt'],
                          updatedAt: orderData['updatedAt'],
                          productQuantity: orderData['productQuantity'],
                          productTotalPrice: orderData['productTotalPrice'],
                          customerId: orderData['customerId'],
                          status: orderData['status'],
                          customerName: orderData['customerName'],
                          customerPhone: orderData['customerPhone'],
                          customerAddress: orderData['customerAddress'],
                          customerDeviceToken: orderData['customerDeviceToken'],
                      );

                      //calculate price
                      cartPriceController.fetchProductPrice();

                      return  Card(
                        color: AppConstant.appTextColor,
                        elevation: 5,
                        child: ListTile(
                          leading: CircleAvatar(backgroundColor: AppConstant.appMainColor,backgroundImage: NetworkImage(orderModel.productImages[0],),),
                          title: Text(orderModel.productName),
                          subtitle: Row(
                            children: [
                              Text(orderModel.productTotalPrice.toString()),
                              SizedBox(width: 20,),
                              orderModel.status!=true
                                  ?Text('Pending..',style: TextStyle(color: Colors.red),)
                                  :Text('Delivered..',style: TextStyle(color: Colors.green),)
                            ],
                          ),
                          trailing: orderModel.status==true
                              ? ElevatedButton(onPressed: (){
                                Get.to(AddReviewScreen(orderModel:orderModel));
                          }, child: Text('Review'))
                          :SizedBox.shrink()

                        ),
                      );
                    },)

              );
          }
          return Container();
        },),

    );
  }
}
