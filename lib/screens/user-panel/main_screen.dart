import 'package:ecom/common/widgets/all_product_widget.dart';
import 'package:ecom/common/widgets/banner_widget.dart';
import 'package:ecom/common/widgets/category_item_widget.dart';
import 'package:ecom/common/widgets/custom_drawer_widget.dart';
import 'package:ecom/common/widgets/flash_sale_widget.dart';
import 'package:ecom/common/widgets/heading_widget.dart';
import 'package:ecom/screens/user-panel/all_products.dart';
import 'package:ecom/screens/user-panel/all_category_screen.dart';
import 'package:ecom/screens/user-panel/all_flash_sale_product.dart';
import 'package:ecom/screens/user-panel/cart_screen.dart';
import 'package:ecom/screens/user-panel/favourite_products.dart';
import 'package:ecom/screens/user-panel/search_screen.dart';
import 'package:ecom/services/fcm_service.dart';
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
        iconTheme: IconThemeData(color: AppConstant.appTextColor),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: AppConstant.appSecondaryColor,
          statusBarIconBrightness: Brightness.light,
        ),
        backgroundColor: AppConstant.appMainColor,
        title: Text(AppConstant.appMainName,style: TextStyle(color: AppConstant.appTextColor),),
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
              SizedBox(height: Get.height/90.0,),
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 10.0),
                  child: BannerWidget()
              ),
              HeadingWidget(headingTitle: 'Categories', headingSubTitle: 'According to your budget', onTap: () {
                        Get.to(AllCategoryScreen());
              }, buttonText: 'See More >',),
              CategoryItemWidget(),

              HeadingWidget(headingTitle: 'Flash Sale', headingSubTitle: 'Low Price', onTap: () {
                Get.to(AllFlashSaleProduct());
              }, buttonText: 'See More >',),
              FlashSaleWidget(),

              HeadingWidget(headingTitle: 'All Products', headingSubTitle: 'According to your budget', onTap: () {
                Get.to(AllProducts());
              }, buttonText: 'See More >',),
              AllProductWidget(),
            ],
          ),
        ),
      ),

    );
  }
}
