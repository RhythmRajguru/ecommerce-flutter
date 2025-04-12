import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:ecom/models/product_model.dart';
import 'package:get/get.dart';
import 'package:ecom/utils/constants/app_constraint.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductDetail extends StatelessWidget {
  ProductModel productModel;
  ProductDetail({required this.productModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
      backgroundColor: AppConstant.appMainColor,
      title: Text('Product Details',style: TextStyle(color: AppConstant.appTextColor),),
      iconTheme: IconThemeData(color: AppConstant.appTextColor),
    ),
      body: Container(
        child: Column(
          children: [
            SizedBox(height: Get.height/60,),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10.0),
          child: CarouselSlider(
          items: productModel.productImages.map((imageUrls)=>
            ClipRRect(borderRadius: BorderRadius.circular(10.0),
             child: CachedNetworkImage(imageUrl: imageUrls,fit: BoxFit.cover,width: Get.width-10,
              placeholder: (context,url)=>ColoredBox(color: Colors.white,child: Center(child: CupertinoActivityIndicator(),),),
              errorWidget: (context,url,error)=>Icon(Icons.error),
              ),),).toList(),
              options: CarouselOptions(
              scrollDirection: Axis.horizontal,
              autoPlay: true,
              aspectRatio: 2.5,
                viewportFraction: 1,
              ),),
        ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          alignment: Alignment.topLeft,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(productModel.productName),
                              Icon(Icons.favorite_border),
                            ],
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          alignment: Alignment.topLeft,
                          child: Text("Category:"+productModel.categoryName)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          alignment: Alignment.topLeft,
                          child:
                             productModel.isSale==true&&productModel.salePrice!=''
                                 ? Row(
                               children: [
                                 Text("Rs."+productModel.salePrice),
                                 SizedBox(width: 10,),
                                 Text(productModel.fullPrice,style: TextStyle(decoration: TextDecoration.lineThrough,color: AppConstant.appMainColor),),
                               ],
                             )
                                 : Text("Rs."+productModel.fullPrice)

                    ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          alignment: Alignment.topLeft,
                          child: Text("Description:"+productModel.productDescription)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Material(child: Container(
                            width: Get.width/3.0,
                            height: Get.height/16,
                            decoration: BoxDecoration(
                              color: AppConstant.appSecondaryColor,
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: TextButton(
                              child: Text('Whatsapp',style: TextStyle(color: AppConstant.appTextColor),),
                              onPressed: (){
                              },
                            ),
                          ),),
                          Material(child: Container(
                            width: Get.width/3.0,
                            height: Get.height/16,
                            decoration: BoxDecoration(
                              color: AppConstant.appSecondaryColor,
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: TextButton(
                              child: Text('Add to Cart',style: TextStyle(color: AppConstant.appTextColor),),
                              onPressed: (){
                              },
                            ),
                          ),),
                        ],
                      )
                    ),

                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
