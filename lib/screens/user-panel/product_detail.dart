import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom/common/widgets/all_reviews_per_product.dart';

import 'package:ecom/contollers/rating_controller.dart';
import 'package:ecom/models/cart_model.dart';
import 'package:ecom/models/order_model.dart';
import 'package:ecom/models/product_model.dart';
import 'package:ecom/models/review_model.dart';
import 'package:ecom/screens/user-panel/cart_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:ecom/utils/constants/app_constraint.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductDetail extends StatelessWidget {
  ProductModel productModel;
  ProductDetail({required this.productModel});

  User? user=FirebaseAuth.instance.currentUser;



  @override
  Widget build(BuildContext context) {
    RatingController ratingController=Get.put(RatingController(productModel.productId));
    return Scaffold(
    appBar: AppBar(
      backgroundColor: AppConstant.appMainColor,
      title: Text('Product Details',style: TextStyle(color: AppConstant.appTextColor),),
      iconTheme: IconThemeData(color: AppConstant.appTextColor),
      actions: [
        IconButton(onPressed: (){
          Get.to(CartScreen());
        }, icon: Icon(Icons.shopping_cart)),
      ],
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
                    //reviews
                   Obx((){
                    return Row(
                       children: [
                         Container(
                           alignment: Alignment.topLeft,
                           child: RatingBar.builder(
                             glow: false,
                             ignoreGestures: true,
                             initialRating: double.parse(ratingController.averageRating.toString()),
                             minRating: 1,
                             direction: Axis.horizontal,
                             allowHalfRating: true,
                             itemCount: 5,
                             itemSize: 25,
                             itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                             itemBuilder: (context, index) =>
                                 Icon(Icons.star,color: Colors.amber,),
                             onRatingUpdate: (value) {

                             },),
                         ),
                         Text(ratingController.averageRating.toString()),
                       ],
                     );
                   }),

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
                                sendMessageOnWhatsapp(
                                  productModel:productModel,
                                );
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
                              onPressed: ()async{
                                await checkProductExistence(uId:user!.uid);
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
            AllReviewsPerProduct(productModel:productModel),
          ],
        ),
      ),
    );
  }
  //check product exist or not
  Future<void> checkProductExistence({required String uId,int quantityIncrement=1})async{

      final DocumentReference documentReference=FirebaseFirestore.instance.collection('cart').doc(uId).collection('cartOrders').doc(productModel.productId.toString());
      DocumentSnapshot snapshot=await documentReference.get();

      if(snapshot.exists){
        int currentQuantity=snapshot['productQuantity'];
        int updatedQuantity=currentQuantity+quantityIncrement;
        double totalPrice=double.parse(productModel.isSale?productModel.salePrice:productModel.fullPrice)*updatedQuantity;

        await documentReference.update({
          'productQuantity':updatedQuantity,
          'productTotalPrice':totalPrice
        });

      }else{
          await FirebaseFirestore.instance.collection('cart').doc(uId).set({
            'uId':uId,
            'createdAt':DateTime.now(),
          },);

          CartModel cartModel=CartModel(
              productId: productModel.productId,
              categoryId: productModel.categoryId,
              productName: productModel.productName,
              categoryName: productModel.categoryName,
              salePrice: productModel.salePrice,
              fullPrice: productModel.fullPrice,
              productImages: productModel.productImages,
              deliveryTime: productModel.deliveryTime,
              isSale: productModel.isSale,
              productDescription: productModel.productDescription,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
              productQuantity: 1,
              productTotalPrice: double.parse(productModel.isSale?productModel.salePrice:productModel.fullPrice)

          );


          await documentReference.set(cartModel.toMap());

      }
  }
  static Future<void> sendMessageOnWhatsapp({required ProductModel productModel})async{
    final String message = "Hello! i want to suggest you this product 😄 \n\n\n "
        "Product name:-${productModel.productName} \n\n"
        "Product Price:-${productModel.isSale?productModel.salePrice:productModel.fullPrice} \n\n"
        "Product Description:-${productModel.productDescription} \n\n\n"
        "App by:- Rhythm Rajguru \n";


    final encodedMessage = Uri.encodeComponent(message);
    final whatsappUrl = "https://wa.me/?text=$encodedMessage";

    if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
      await launchUrl(Uri.parse(whatsappUrl), mode: LaunchMode.externalApplication);
    } else {
     Get.snackbar('Error', 'Problem while sharing');

  }
  }
}
