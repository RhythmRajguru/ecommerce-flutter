import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom/models/cart_model.dart';
import 'package:ecom/models/product_model.dart';
import 'package:ecom/screens/user-panel/product_detail.dart';
import 'package:ecom/utils/constants/app_constraint.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_card/image_card.dart';

class CartScreen extends StatelessWidget {

  User? user=FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstant.appMainColor,
        title: Text('Cart',style: TextStyle(color: AppConstant.appTextColor),),
        iconTheme: IconThemeData(color: AppConstant.appTextColor),
      ),
       body: FutureBuilder(
         future: FirebaseFirestore.instance.collection('cart').doc(user!.uid).collection('cartOrders').get(),
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
                  return Card(
                    color: AppConstant.appTextColor,
                    elevation: 5,
                    child: ListTile(
                      leading: CircleAvatar(backgroundColor: AppConstant.appMainColor,backgroundImage: NetworkImage(cartModel.productImages[0],),),
                      title: Text(cartModel.productName),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(cartModel.productTotalPrice.toString()),
                         Row(
                           children: [
                             CircleAvatar(radius: 14.0,backgroundColor: AppConstant.appMainColor,child: Icon(Icons.remove,color: AppConstant.appTextColor,),),
                             SizedBox(width: 10,),
                             CircleAvatar(radius: 14.0,backgroundColor: AppConstant.appMainColor,child: Icon(Icons.add,color: AppConstant.appTextColor,),),
                           ],
                         )
                        ],
                      ),
                    ),
                  );
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
                child: Text('Total '+'Rs.'+'1200.00',style: TextStyle(fontWeight: FontWeight.bold),)),
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
                  child: Text('Checkout',style: TextStyle(color: AppConstant.appTextColor),),
                  onPressed: (){

                  },
                ),
              ),),
            ),
          ],
        ),
      ),
    );
  }
}
