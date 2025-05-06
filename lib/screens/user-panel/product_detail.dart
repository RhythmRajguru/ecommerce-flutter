import 'dart:ffi';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom/common/widgets/address_widget.dart';
import 'package:ecom/common/widgets/all_reviews_per_product.dart';
import 'package:ecom/common/widgets/custom_bottom_btn.dart';
import 'package:ecom/common/widgets/product_images_widget.dart';
import 'package:ecom/common/widgets/product_size_widget.dart';
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
  String? size;

  @override
  Widget build(BuildContext context) {
    FavouriteController favouriteController=Get.put(FavouriteController(productModel: widget.productModel));
    RatingController ratingController=Get.put(RatingController(widget.productModel.productId));
    return Scaffold(
    appBar: AppBar(
      centerTitle: true,
      title: Text(widget.productModel.productName,style: TextStyle(fontFamily: 'Inter',fontSize: 20),),
      actions: [
        IconButton(onPressed: (){
          Get.to(CartScreen());
        }, icon: Icon(Icons.shopping_cart)),
      ],
    ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: kBottomNavigationBarHeight + 10),
        child: Container(

          child: Column(
            children: [
          Container(
            height: 400,
              margin: EdgeInsets.symmetric(horizontal: 10.0),
              child: CarouselSlider(
              items: widget.productModel.productImages.map((imageUrls)=>
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                 child: CachedNetworkImage(imageUrl: imageUrls,fit: BoxFit.cover,height: 400,width: Get.width-10,
                  placeholder: (context,url)=>ColoredBox(color: Colors.white,child: Center(child: CupertinoActivityIndicator(),),),
                  errorWidget: (context,url,error)=>Icon(Icons.error),
                  ),),).toList(),
                  options: CarouselOptions(
                  scrollDirection: Axis.horizontal,
                  autoPlay: true,
                  aspectRatio: 2.5,
                    viewportFraction: 1,
                    height: 400
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
                                Column(
                                  children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(

                                alignment: Alignment.topLeft,
                                  child:Text(widget.productModel.productName,style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Inter',fontSize: 16),)),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                        border: Border.all(
                                            color: Colors.grey.shade400,
                                            width: 1
                                        )
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: InkWell(
                                          onTap: (){
                                            ProductDetail.sendMessageOnWhatsapp(
                                              productModel:widget.productModel,
                                            );
                                          },
                                          child: Icon(Icons.share)),
                                    ),
                                  )
                              ],
                            ),
                                   Container(
                                          alignment: Alignment.topLeft,
                                          child:
                                          (widget.productModel.isSale==true&&widget.productModel.salePrice!='')
                                              ? Row(
                                            children: [
                                              Text('₹',style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Inter',fontSize: 16),),
                                              Text(widget.productModel.salePrice,style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Inter',fontSize: 16),),
                                              SizedBox(width: 10,),
                                              Text(widget.productModel.fullPrice,style: TextStyle(decoration: TextDecoration.lineThrough,color: Colors.red,fontWeight: FontWeight.bold,fontFamily: 'Inter',fontSize: 18),),
                                            ],
                                          )
                                              : Text("₹"+widget.productModel.fullPrice,style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Inter',fontSize: 16),)

                                      ),
                                  ],
                                ),

                              ],
                            )),
                      ),

                      Container(
                          margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                          child: ProductImagesWidget(productModel: widget.productModel)),
                      Container(
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.only(left: 10,top: 10,right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Size',style: TextStyle(fontFamily: 'Inter',fontSize: 14,fontWeight: FontWeight.w600),),
                              Text('Size Guide',style: TextStyle(fontFamily: 'Inter',fontSize: 14,color: Colors.grey),),
                            ],
                          )),
                      ProductSizeWidget(productModel: widget.productModel, sizes: widget.productModel.sizes, onSelected: (String selectedSize) {
                        size=selectedSize;
                      },),

                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                          Align(
                              alignment:Alignment.topLeft,
                              child: Text('Description',style: TextStyle(fontFamily: 'Inter',fontSize: 14,fontWeight: FontWeight.bold),)),
                            Container(
                                child: Text(widget.productModel.productDescription,style: TextStyle(fontFamily: 'Inter',fontWeight: FontWeight.w600,fontSize: 14,color: Colors.grey),)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(left: 20,top: 10),
                  child: Text('Delivery & Services',style: TextStyle(fontFamily: 'Inter',fontSize: 14,fontWeight: FontWeight.bold),)),
              Container(
                margin: EdgeInsets.only(top: 10,right: 20,left: 20,bottom: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.grey.shade400,
                      width: 1
                    )
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: AddressWidget(),
                  )),
             Column(
               children: [
               Container(
                 margin: EdgeInsets.symmetric(horizontal: 10),
                 child: ListTile(
                   dense: true,
                   minVerticalPadding: 5,
                   visualDensity: VisualDensity(vertical: -4),
                   leading: Image.asset('assets/icons/truck.png'),
                   title: Text('Enjoy Free Delivery',style: TextStyle(fontFamily: 'Inter',fontSize: 14,fontWeight: FontWeight.bold),),
                   subtitle: Row(
                     children: [
                       Text('No Delivery Fee',style: TextStyle(fontFamily: 'Inter',fontSize: 14,)),
                       SizedBox(width: 5,),
                       Text('₹149',style: TextStyle(fontFamily: 'Inter',fontSize: 14,decoration: TextDecoration.lineThrough)),
                     ],
                   ),
                 ),
               ),
                 Container(
                   margin: EdgeInsets.symmetric(horizontal: 10),
                   child: ListTile(
                     dense: true,
                     minVerticalPadding: 5,
                     visualDensity: VisualDensity(vertical: -4),
                     leading: Image.asset('assets/icons/money.png'),
                     title: Text('Pay on Delivery us Available',style: TextStyle(fontFamily: 'Inter',fontSize: 14,fontWeight: FontWeight.bold),),
                     subtitle: Text('₹10 additional fee applicable',style: TextStyle(fontFamily: 'Inter',fontSize: 14,)),
                   ),
                 ),
                 Container(
                   margin: EdgeInsets.symmetric(horizontal: 10),
                   child: ListTile(
                     dense: true,
                     minVerticalPadding: 10,
                     visualDensity: VisualDensity(vertical: -4),
                     leading: Image.asset('assets/icons/exchange.png'),
                     title: Text('Hassle free 7 days Return & Exchange',style: TextStyle(fontFamily: 'Inter',fontSize: 14,fontWeight: FontWeight.bold),),
                   ),
                 )

               ],
             ),

             Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 Container(
                     margin: EdgeInsets.only(left: 20,top: 30),
                     child: Text('Rating & Reviews',style: TextStyle(fontFamily: 'Inter',fontSize: 14,fontWeight: FontWeight.bold),)),
                 InkWell(
                   onTap: (){
                     Get.to(()=>AllReviewsPerproductScreen(productModel: widget.productModel,));
                   },
                  child:  Container(
                      margin: EdgeInsets.only(right: 10,top: 30),
                      child: Text('View All',style: TextStyle(color: Colors.grey,fontSize: 12,fontWeight: FontWeight.bold))),
                 ),
               ],
             ),
              Container(
                height: 120, // or any scrollable height
                child: AllReviewsPerProduct(productModel: widget.productModel),
              ),

            ],
          ),
        ),
      ),
      bottomSheet: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Material(child: Container(
                width: Get.width/2.3,
                height: 50,
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
              Material(child: Container(
                width: Get.width/2.3,
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.green
                  ),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: InkWell(
                  onTap: ()async{
                    if(size != null && size!.isNotEmpty){
                      await checkProductExistence(uId:user!.uid);
                      Get.snackbar('Success', 'Product successfully added to cart',snackPosition: SnackPosition.BOTTOM);
                    }else{
                      Get.snackbar('Error', 'Please select at least one size',snackPosition: SnackPosition.BOTTOM);
                    }

                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shopping_cart,color: Colors.green,),
                      SizedBox(width: 5,),
                      Text('Add to Cart',style: TextStyle(color: Colors.green),),
                    ],
                  ),
                ),
              ),),
            ],
          )
      ),
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
              size: size.toString(),
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
