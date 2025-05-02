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
                  child:GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,mainAxisSpacing: 0,crossAxisSpacing: 0,mainAxisExtent: 350),
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

                      return InkWell(
                        onTap: (){

                        },
                        child:   Container(
                          margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                          child: Column(

                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                  height: 200,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(image: NetworkImage(orderModel.productImages[0]),fit: BoxFit.cover)
                                  )),
                              SizedBox(height: 5,),
                              Container(
                                  alignment: Alignment.centerLeft,
                                  margin: EdgeInsets.symmetric(horizontal: 5),
                                  child: Text(orderModel.productName,style: TextStyle(fontSize: 14,fontFamily: 'Inter'),)),
                              SizedBox(height: 2,),
                              orderModel.isSale
                                  ?Row(
                                  children: [
                                    Container(
                                        margin: EdgeInsets.symmetric(horizontal: 5),
                                        child: Text("₹ "+orderModel.salePrice,style: TextStyle(fontWeight: FontWeight.w600,fontFamily: 'Inter'),)),
                                    SizedBox(width: 10,),
                                    Text(orderModel.fullPrice,style: TextStyle(decoration: TextDecoration.lineThrough,color: Colors.red,fontWeight: FontWeight.w600,fontFamily: 'Inter'))
                                  ]
                              )
                                  :Container(
                                alignment: Alignment.centerLeft,
                                  margin: EdgeInsets.symmetric(horizontal: 5),
                                  child: Text("₹ "+orderModel.fullPrice,style: TextStyle(fontWeight: FontWeight.w600,fontFamily: 'Inter'))),
                              Row(
                                children: [
                                  Container(
                                      margin: EdgeInsets.symmetric(horizontal: 5),
                                      child: Text('Status:',style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w600,fontFamily: 'Inter'),)),
                                  SizedBox(width: 5,),
                                  orderModel.status!=true
                                      ?Text('Pending..',style: TextStyle(color: Colors.red,fontFamily: 'Inter',fontWeight: FontWeight.w600),)
                                      :Text('Delivered..',style: TextStyle(color: Colors.green,fontFamily: 'Inter',fontWeight: FontWeight.w600),),
                                ],
                              ),

                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  onTap: (){
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

                                      border: Border.all(
                                        color: AppConstant.appMainColor,
                                        width: 1
                                      ),
                                      borderRadius: BorderRadius.circular(10)
                                    ),
                                    child: Center(child: Text('Review',style: TextStyle(color: AppConstant.appMainColor,fontFamily: 'Inter',fontWeight: FontWeight.bold),)),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),


                      );
                    }, )

              );
          }
          return Container();
        },),

    );
  }
}
