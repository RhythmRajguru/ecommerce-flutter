import 'dart:ffi';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom/common/widgets/all_reviews_per_product.dart';
import 'package:ecom/common/widgets/custom_bottom_btn.dart';
import 'package:ecom/contollers/favourite_controller.dart';

import 'package:ecom/contollers/rating_controller.dart';
import 'package:ecom/models/cart_model.dart';
import 'package:ecom/models/order_model.dart';
import 'package:ecom/models/product_model.dart';
import 'package:ecom/models/review_model.dart';
import 'package:ecom/screens/user-panel/all_reviews_perproduct_screen.dart';
import 'package:ecom/screens/user-panel/cart_screen.dart';
import 'package:ecom/screens/user-panel/favourite_products.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:ecom/utils/constants/app_constraint.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductDetail extends StatefulWidget {
  ProductModel productModel;
  ProductDetail({required this.productModel});

  @override
  State<ProductDetail> createState() => _ProductDetailState();

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

class _ProductDetailState extends State<ProductDetail> {
  User? user=FirebaseAuth.instance.currentUser;
  

  @override
  Widget build(BuildContext context) {
    FavouriteController favouriteController=Get.put(FavouriteController(productModel: widget.productModel));
    RatingController ratingController=Get.put(RatingController(widget.productModel.productId));
    return Scaffold(
    appBar: AppBar(
      actions: [
        IconButton(onPressed: (){
          Get.to(CartScreen());
        }, icon: Icon(Icons.shopping_cart)),
      ],
    ),
      body: Column(
        children: [

      Container(
        margin: EdgeInsets.symmetric(horizontal: 10.0),
        child: CarouselSlider(
        items: widget.productModel.productImages.map((imageUrls)=>
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
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
            child: Container(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        alignment: Alignment.topLeft,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(widget.productModel.productName,style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Inter',fontSize: 18),),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                      alignment: Alignment.topLeft,
                                      child:
                                      (widget.productModel.isSale==true&&widget.productModel.salePrice!='')
                                          ? Row(
                                        children: [
                                          Text('Rs.',style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Inter',fontSize: 18),),
                                          Text(widget.productModel.salePrice,style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Inter',fontSize: 18),),
                                          SizedBox(width: 10,),
                                          Text(widget.productModel.fullPrice,style: TextStyle(decoration: TextDecoration.lineThrough,color: Colors.red,fontWeight: FontWeight.bold,fontFamily: 'Inter',fontSize: 18),),
                                        ],
                                      )
                                          : Text("Rs."+widget.productModel.fullPrice,style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Inter',fontSize: 18),)

                                  ),
                                ),
                              ],
                            ),
                          ],
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                    child: Row(
                      children: [
                        Text('Category: ',style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Inter',fontSize: 16,),),
                        Text(widget.productModel.categoryName,style: TextStyle(fontFamily: 'Inter',fontSize: 16,)),
                      ],
                      mainAxisAlignment: MainAxisAlignment.start,
                    ),
                  ),
                 Obx((){
                  return Row(
                     children: [
                       Container(
                         margin: EdgeInsets.only(left: 10,right: 10),
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
                       Text(ratingController.averageRating.value.toString(),style: TextStyle(fontFamily: 'Inter',fontSize: 16,),)
                     ],
                   );
                 }),

                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                      Align(
                          alignment:Alignment.topLeft,
                          child: Text('Description',style: TextStyle(fontFamily: 'Inter',fontSize: 14,fontWeight: FontWeight.bold),)),
                        Container(
                            child: Text(widget.productModel.productDescription,style: TextStyle(fontFamily: 'Inter',fontSize: 14,),)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Material(child: Container(
                          width: Get.width/2.5,
                          height: Get.height/16,
                          decoration: BoxDecoration(
                            color: Colors.green.shade400,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: InkWell(
                            onTap: (){
                              ProductDetail.sendMessageOnWhatsapp(
                                productModel:widget.productModel,
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.share,color: Colors.white,),
                                  SizedBox(width: 5,),
                                  Text('Whatsapp',style: TextStyle(color: Colors.white),),
                                ],
                              ),
                          ),

                        ),),
                        Material(child: Container(
                          width: Get.width/2.5,
                          height: Get.height/16,
                          decoration: BoxDecoration(
                            color: Colors.red.shade400,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: InkWell(
                            onTap: (){
                              favouriteController.addFavouriteProduct();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.favorite_outline_rounded,color: Colors.white,),
                                SizedBox(width: 5,),
                                Text('Wishlist',style: TextStyle(color: Colors.white),),
                              ],
                            ),
                          ),
                        ),),
                      ],
                    )
                  ),
                ],
              ),
            ),
          ),
         Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [
             Container(
                 margin: EdgeInsets.only(left: 20),
                 child: Text('Reviews',style: TextStyle(fontFamily: 'Inter',fontSize: 14,fontWeight: FontWeight.bold),)),
             InkWell(
               onTap: (){
                 Get.to(()=>AllReviewsPerproductScreen(productModel: widget.productModel,));
               },
              child:  Container(
                  margin: EdgeInsets.only(right: 20),
                  child: Text('View All',style: TextStyle(color: Colors.grey,fontSize: 12,fontWeight: FontWeight.bold))),
             ),
           ],
         ),
          AllReviewsPerProduct(productModel:widget.productModel),
        ],
      ),
      bottomSheet: CustomBottomBtn(title: 'Add to Cart', callback: ()async{
        await checkProductExistence(uId:user!.uid);
        Get.snackbar('Success', 'Product successfully added to cart',snackPosition: SnackPosition.BOTTOM);
      }),
    );
  }
  
  //check product exist or not
  Future<void> checkProductExistence({required String uId,int quantityIncrement=1})async{

      final DocumentReference documentReference=FirebaseFirestore.instance.collection('cart').doc(uId).collection('cartOrders').doc(widget.productModel.productId.toString());
      DocumentSnapshot snapshot=await documentReference.get();

      if(snapshot.exists){
        int currentQuantity=snapshot['productQuantity'];
        int updatedQuantity=currentQuantity+quantityIncrement;
        double totalPrice=double.parse(widget.productModel.isSale?widget.productModel.salePrice:widget.productModel.fullPrice)*updatedQuantity;

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
              productId: widget.productModel.productId,
              categoryId: widget.productModel.categoryId,
              productName: widget.productModel.productName,
              categoryName: widget.productModel.categoryName,
              salePrice: widget.productModel.salePrice,
              fullPrice: widget.productModel.fullPrice,
              productImages: widget.productModel.productImages,
              deliveryTime: widget.productModel.deliveryTime,
              isSale: widget.productModel.isSale,
              productDescription: widget.productModel.productDescription,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
              productQuantity: 1,
              productTotalPrice: double.parse(widget.productModel.isSale?widget.productModel.salePrice:widget.productModel.fullPrice)

          );


          await documentReference.set(cartModel.toMap());

      }
  }
}
