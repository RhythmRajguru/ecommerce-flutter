import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom/contollers/cart_price_controller.dart';
import 'package:ecom/models/cart_model.dart';
import 'package:ecom/models/product_model.dart';
import 'package:ecom/screens/user-panel/cart_screen.dart';
import 'package:ecom/screens/user-panel/main_screen.dart';
import 'package:ecom/screens/user-panel/product_detail.dart';
import 'package:ecom/utils/constants/app_constraint.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:get/get.dart';
import 'package:image_card/image_card.dart';

import '../../contollers/cutomer_devicetoken_controller.dart';
import '../../services/placeorder_service.dart';

class CheckoutScreen extends StatelessWidget {

  User? user=FirebaseAuth.instance.currentUser;

  final CartPriceController cartPriceController=Get.put(CartPriceController());

  final nameController=TextEditingController();
  final phoneController=TextEditingController();
  final addressController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstant.appMainColor,
        title: Text('Checkout',style: TextStyle(color: AppConstant.appTextColor),),
        iconTheme: IconThemeData(color: AppConstant.appTextColor),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('cart').doc(user!.uid).collection('cartOrders').snapshots(),
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
                      final cartData=snapshot.data!.docs[index];

                      CartModel cartModel=CartModel(
                          productId: cartData['productId'],
                          categoryId: cartData['categoryId'],
                          productName: cartData['productName'],
                          categoryName: cartData['categoryName'],
                          salePrice: cartData['salePrice'],
                          fullPrice: cartData['fullPrice'],
                          productImages: cartData['productImages'],
                          deliveryTime: cartData['deliveryTime'],
                          isSale: cartData['isSale'],
                          productDescription: cartData['productDescription'],
                          createdAt: cartData['createdAt'],
                          updatedAt: cartData['updatedAt'],
                          productQuantity: cartData['productQuantity'],
                          productTotalPrice: cartData['productTotalPrice']);

                      //calculate price
                      cartPriceController.fetchProductPrice();

                      return SwipeActionCell
                        (key: ObjectKey(cartModel.productId),
                        trailingActions: [
                          SwipeAction(
                              title: 'Delete',
                              forceAlignmentToBoundary: true,
                              performsFirstActionWithFullSwipe: true,
                              onTap: (CompletionHandler handler)async{
                                await FirebaseFirestore.instance.collection('cart').doc(user!.uid).collection('cartOrders').doc(cartModel.productId).delete();
                              })
                        ],
                        child: Card(
                          color: AppConstant.appTextColor,
                          elevation: 5,
                          child: ListTile(
                            leading: CircleAvatar(backgroundColor: AppConstant.appMainColor,backgroundImage: NetworkImage(cartModel.productImages[0],),),
                            title: Text(cartModel.productName),
                            subtitle: Text(cartModel.productTotalPrice.toString()),

                          ),
                        ),);
                    },)

              );
          }
          return Container();
        },),

      bottomNavigationBar: Container(
        margin: EdgeInsets.only(bottom: 5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                margin: EdgeInsets.symmetric(horizontal: 10.0),
                child: Obx(() {
                  return Text('Total '+'Rs.'+cartPriceController.totalPrice.value.toStringAsFixed(1),style: TextStyle(fontWeight: FontWeight.bold),);
                },)),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(child: Container(
                width: Get.width/2.0,
                height: Get.height/18,
                decoration: BoxDecoration(
                  color: AppConstant.appSecondaryColor,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: TextButton(
                  child: Text('Confirm Order',style: TextStyle(color: AppConstant.appTextColor),),
                  onPressed: (){
                    showCustomBottomSheet(context);
                  },
                ),
              ),),
            ),
          ],
        ),
      ),
    );
  }

  void showCustomBottomSheet(BuildContext context) {
    Get.bottomSheet(
      Container(height: 350,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 10.0),
                child: TextFormField(
                    maxLines: 1,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                      hintStyle: TextStyle(fontSize: 12),
                    ),
                  ),

              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 10.0),
                child:  TextFormField(
                    maxLines: 1,
                    maxLength: 10,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    controller: phoneController,
                    decoration: InputDecoration(
                      labelText: 'Phone',
                      prefixIcon: Icon(Icons.phone),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                      hintStyle: TextStyle(fontSize: 12),
                    ),
                  ),

              ),
              Padding(
                padding: const EdgeInsets.only(top: 0,left: 20,right: 20,bottom: 20),
                child: TextFormField(
                    maxLines: 3,
                    keyboardType: TextInputType.streetAddress,
                    textInputAction: TextInputAction.next,
                    controller: addressController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.location_pin),
                      labelText: 'Address',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 10.0),
                      hintStyle: TextStyle(fontSize: 12),
                    ),
                  ),

              ),
              SizedBox(
                width: 150,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstant.appMainColor,
                    padding: EdgeInsets.fromLTRB(10,10,10,10)
                  ),
                    onPressed: ()async{
                    if(nameController.text!='' && phoneController.text!='' && addressController.text!=''){
                      String name=nameController.text.trim();
                      String phone=phoneController.text.trim();
                      String address=addressController.text.trim();

                      String customerToken=await getCustomerDeviceToken();

                      placeOrder(
                        context:context,
                        customerName:name,
                        customerPhone:phone,
                        customerAddress:address,
                        customerDeviceToken:customerToken,
                      );

                    }else{
                      Get.snackbar('Error', 'Please fill all details');
                    }
                }, child: Text('Place Order',style: TextStyle(color: AppConstant.appTextColor),)),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
      elevation: 6,
      shape: RoundedRectangleBorder()
    );
  }
}
