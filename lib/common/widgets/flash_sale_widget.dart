import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom/models/category_model.dart';
import 'package:ecom/models/product_model.dart';
import 'package:ecom/screens/user-panel/product_detail.dart';
import 'package:ecom/utils/constants/app_constraint.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_card/image_card.dart';

class FlashSaleWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance.collection('products').where('isSale',isEqualTo: true).get(),
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
          return Container(
            height: 280,
            child: ListView.builder(itemBuilder: (context, index) {
              final productData=snapshot.data!.docs[index];
              ProductModel productModel=ProductModel(
                  productId: productData['productId'],
                  categoryId: productData['categoryId'],
                  productName: productData['productName'],
                  categoryName: productData['categoryName'],
                  salePrice: productData['salePrice'],
                  fullPrice: productData['fullPrice'],
                  productImages: productData['productImages'],
                  deliveryTime: productData['deliveryTime'],
                  isSale: productData['isSale'],
                  productDescription: productData['productDescription'],
                  createdAt: productData['createdAt'],
                  updatedAt: productData['updatedAt']);
              return InkWell(
                onTap: (){
                  Get.to(()=>ProductDetail(productModel: productModel,));
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 10,left: 10,bottom: 10),
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            height: 200,
                            width: 170,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(16),topRight: Radius.circular(16)),
                                image: DecorationImage(image: NetworkImage(productModel.productImages[0]),fit: BoxFit.cover)
                            )),
                        SizedBox(height: 5,),
                        Container(
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(productModel.productName,style: TextStyle(fontSize: 14,fontFamily: 'Inter',fontWeight: FontWeight.w600),)),
                        Container(
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            child: Text('₹'+productModel.salePrice,style: TextStyle(fontSize: 14,fontFamily: 'Inter',fontWeight: FontWeight.w600),)),

                      ],
                    ),
                  ),
                ),
              );
            },itemCount: snapshot.data!.docs.length,shrinkWrap: true,scrollDirection: Axis.horizontal,),
          );
        }
        return Container();
      },);
  }
}
