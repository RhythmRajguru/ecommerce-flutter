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
        centerTitle: true,
        title: Text('All Orders',style: TextStyle(color: Colors.black),),

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

                      return  InkWell(
                        onTap: (){
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          child: Card(
                            color: Colors.white,
                            elevation: 5,
                            child:
                            Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: SizedBox(
                                        height: 130,
                                        width: 100,
                                        child: Image.network(orderModel.productImages[0],fit: BoxFit.cover,),
                                      ),
                                      margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                                    ),
                                    SizedBox(height: 10,),
                                    Container(
                                      margin: EdgeInsets.symmetric(horizontal: 10),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: 20,),
                                          Text(orderModel.productName,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600,fontFamily: 'Inter'),),
                                          SizedBox(height: 10,),
                                          orderModel.isSale
                                              ?Row(
                                              children: [
                                                Text("₹ "+orderModel.salePrice,style: TextStyle(fontWeight: FontWeight.w600,fontFamily: 'Inter'),),
                                                SizedBox(width: 10,),
                                                Text(orderModel.fullPrice,style: TextStyle(decoration: TextDecoration.lineThrough,color: Colors.red,fontWeight: FontWeight.w600,fontFamily: 'Inter'))
                                              ]
                                          )
                                              :Text(orderModel.fullPrice,),
                                          SizedBox(height: 10,),
                                        Row(
                                          children: [
                                            Text('Status:',style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w600,fontFamily: 'Inter'),),
                                            SizedBox(width: 5,),
                                            orderModel.status!=true
                                                ?Text('Pending..',style: TextStyle(color: Colors.red,fontFamily: 'Inter',fontWeight: FontWeight.w600),)
                                                :Text('Delivered..',style: TextStyle(color: Colors.green,fontFamily: 'Inter',fontWeight: FontWeight.w600),),
                                          ],
                                        ),


                                        ],
                                      ),
                                    )
                                  ],

                                ),
                                                InkWell(
                          onTap:(){
                            if(orderModel.status==true){
                              Get.to(()=>AddReviewScreen(orderModel:orderModel));
                            }else{
                              Get.snackbar('Error', 'Order is not delivered yet\nyou cannot write Review',snackPosition: SnackPosition.BOTTOM);
                            }
                          },
                          child: Container(
                          height: 30,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppConstant.appMainColor
                          ),
                          child: Center(child: Text('Review',style: TextStyle(color: Colors.white),)),),
                                                )
                              ],
                            ),

                          ),
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
