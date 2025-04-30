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

class AllProducts extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('All Products',style: TextStyle(color: Colors.black),),
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance.collection('products').where('isSale',isEqualTo: false).get(),
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
            return ListView.builder(itemBuilder: (context, index) {

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
                  Get.to(ProductDetail(productModel: productModel));
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Card(
                    color: Colors.white,
                    elevation: 5,
                    child:
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: SizedBox(
                            height: 130,
                            width: 100,
                            child: Image.network(productModel.productImages[0],fit: BoxFit.cover,),
                          ),
                          margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 20,),
                                Text(productModel.productName,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,fontFamily: 'Inter'),),
                                SizedBox(height: 10,),
                                productModel.isSale
                                    ?Row(
                                    children: [
                                      Text("₹ "+productModel.salePrice,style: TextStyle(fontWeight: FontWeight.w600),),
                                      SizedBox(width: 10,),
                                      Text(productModel.fullPrice,style: TextStyle(decoration: TextDecoration.lineThrough,color: Colors.red,fontWeight: FontWeight.w600))
                                    ]
                                )
                                    :Text("₹ "+productModel.fullPrice,),
                                SizedBox(height: 10,),
                                Text(productModel.productDescription,maxLines: 3,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 14,fontFamily: 'Inter',color: Colors.grey,),),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },itemCount: snapshot.data!.docs.length,shrinkWrap: true,);
          }
          return Container();
        },),
    );
  }
}
