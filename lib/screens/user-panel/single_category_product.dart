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

class SingleCategoryProduct extends StatelessWidget {
  String categoryId;
  String categoryName;
  SingleCategoryProduct({required this.categoryId,required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(categoryName,style: TextStyle(color: Colors.black),),

      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance.collection('products').where('categoryId',isEqualTo: categoryId).get(),
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
            return Center(child: Text('No Category found'),);
          }
          if(snapshot.data!=null){
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,mainAxisSpacing: 3,crossAxisSpacing: 3,mainAxisExtent: 150),
              itemBuilder: (context, index) {
                final productData=snapshot.data!.docs[index];
               ProductModel productModel=ProductModel(
                   productId: productData['productId'],
                   categoryId: productData['categoryId'],
                   productName: productData['productName'],
                   categoryName: productData['categoryName'],
                   salePrice: productData['salePrice'],
                   fullPrice: productData['fullPrice'],
                   sizes: productData['sizes'],
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
                  child:   Container(
                    margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                    child: Column(

                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            height: 100,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(image: NetworkImage(productModel.productImages[0]),fit: BoxFit.cover)
                            )),
                        SizedBox(height: 5,),
                         Text(productModel.productName,style: TextStyle(fontSize: 14,fontFamily: 'Inter'),),
                      ],
                    ),
                  ),


                );
              },itemCount: snapshot.data!.docs.length,shrinkWrap: true,
            );
          }
          return Container();
        },),
    );
  }

}
