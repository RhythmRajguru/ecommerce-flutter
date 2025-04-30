import 'package:ecom/common/widgets/all_product_widget.dart';
import 'package:ecom/common/widgets/banner_widget.dart';
import 'package:ecom/common/widgets/category_item_widget.dart';
import 'package:ecom/common/widgets/custom_drawer_widget.dart';
import 'package:ecom/common/widgets/flash_sale_widget.dart';
import 'package:ecom/screens/user-panel/all_category_screen.dart';
import 'package:ecom/screens/user-panel/all_flash_sale_product.dart';
import 'package:ecom/screens/user-panel/all_products.dart';
import 'package:ecom/screens/user-panel/cart_screen.dart';
import 'package:ecom/screens/user-panel/favourite_products.dart';
import 'package:ecom/screens/user-panel/search_screen.dart';
import 'package:ecom/services/fcm_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../services/notification_service.dart';
import '../../utils/constants/app_constraint.dart';

class MainScreen extends StatefulWidget {

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  NotificationService notificationService=NotificationService();

  User? user=FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notificationService.requestNotificationPermission();
    notificationService.getDeviceToken();
    FcmService.firebaseInit();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppConstant.appMainName,style: TextStyle(color: Colors.black),),
        actions: [
          IconButton(onPressed: (){
            Get.to(SearchScreen());
          }, icon: Icon(Icons.search)),
          IconButton(onPressed: (){
            Get.to(CartScreen());
          }, icon: Icon(Icons.shopping_cart)),
          IconButton(onPressed: (){
            Get.to(FavouriteProducts());
          }, icon: Icon(Icons.favorite)),
        ],
      ),
      drawer: CustomDrawerWidget(),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          child: Column(
            children: [
             Column(
               children: [
                 Container(
                     alignment: Alignment.centerLeft,
                     margin: EdgeInsets.symmetric(horizontal: 20),
                     child: Text('Hello',style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Inter',fontSize: 22),)),
                 Container(
                     alignment: Alignment.centerLeft,
                     margin: EdgeInsets.symmetric(horizontal: 20),
                     child: (user!.displayName.toString().isNotEmpty && user!.displayName!=null)
                     ?Text('Welcome ' + user!.displayName.toString(),style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Inter',fontSize: 14,color: Colors.grey))
                     :Text('Welcome ' + user!.email.toString(),style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Inter',fontSize: 14,color: Colors.grey))),
               ],
             ),
              Container(
                margin: EdgeInsets.only(top: 20,left: 10,right: 10,bottom: 20),
                child: TextField(
                  readOnly: true,
                  onTap: (){
                    Get.to(()=>SearchScreen());
                  },
                  decoration: InputDecoration(
                      hintText: 'Search products here',
                      prefixIcon: Icon(Icons.search,color: Colors.black,),
                      filled: true,
                      fillColor: Colors.grey[250],
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide.none
                      )
                  ),
                ),
              ),
              SizedBox(height: Get.height/90.0,),
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 10.0),
                  child: BannerWidget()
              ),
              Container(
                margin: EdgeInsets.only(left: 20,right: 20,top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Categories',style: TextStyle(fontFamily: 'Inter',fontWeight: FontWeight.bold,fontSize: 16),),
                    InkWell(
                        onTap: (){
                          Get.to(()=>AllCategoryScreen());
                        },
                        child: Text('View All',style: TextStyle(fontFamily: 'Inter',fontWeight: FontWeight.bold,fontSize: 14,color: Colors.grey))),
                  ],
                ),
              ),
              CategoryItemWidget(),

              Container(
                margin: EdgeInsets.only(left: 20,right: 20,top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Flash Sale',style: TextStyle(fontFamily: 'Inter',fontWeight: FontWeight.bold,fontSize: 16),),
                    InkWell(
                        onTap: (){
                          Get.to(()=>AllFlashSaleProduct());
                        },
                        child: Text('View All',style: TextStyle(fontFamily: 'Inter',fontWeight: FontWeight.bold,fontSize: 14,color: Colors.grey))),
                  ],
                ),
              ),
              FlashSaleWidget(),

              Container(
                margin: EdgeInsets.only(left: 20,right: 20,top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('All Products',style: TextStyle(fontFamily: 'Inter',fontWeight: FontWeight.bold,fontSize: 16),),
                    InkWell(
                        onTap: (){
                          Get.to(()=>AllProducts());
                        },
                        child: Text('View All',style: TextStyle(fontFamily: 'Inter',fontWeight: FontWeight.bold,fontSize: 14,color: Colors.grey))),
                  ],
                ),
              ),
              AllProductWidget(),
            ],
          ),
        ),
      ),

    );
  }
}
