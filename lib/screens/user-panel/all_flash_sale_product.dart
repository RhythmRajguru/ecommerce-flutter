import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom/models/category_model.dart';
import 'package:ecom/models/product_model.dart';
import 'package:ecom/screens/user-panel/product_detail.dart';
import 'package:ecom/screens/user-panel/single_category_product.dart';
import 'package:ecom/utils/constants/app_constraint.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_card/image_card.dart';

class AllFlashSaleProduct extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstant.appMainColor,
        title: Text('All Flash Sale Products',style: TextStyle(color: AppConstant.appTextColor),),
        iconTheme: IconThemeData(color: AppConstant.appTextColor),
      ),
      body: FutureBuilder(
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
            return Center(child: Text('No Category found'),);
          }
          if(snapshot.data!=null){
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,mainAxisSpacing: 3,crossAxisSpacing: 3,childAspectRatio: 1.19),
              itemBuilder: (context, index) {
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
                return Row(
                  children: [
                    Padding(padding: EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: ()=>Get.to(ProductDetail(productModel: productModel)),
                        child: Container(
                          child: FillImageCard(
                            imageProvider: CachedNetworkImageProvider(productModel.productImages[0]),
                            width: Get.width/2.3,
                            heightImage: Get.height/10,
                            borderRadius: 20.0,
                            title: Center(child: Text(productModel.productName,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 12.0,fontWeight: FontWeight.w800),)),
                          ),
                        ),
                      ),),
                  ],
                );
              },itemCount: snapshot.data!.docs.length,shrinkWrap: true,
            );
          }
          return Container();
        },),
    );
  }
}
