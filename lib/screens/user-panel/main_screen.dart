import 'package:ecom/common/widgets/banner_widget.dart';
import 'package:ecom/common/widgets/category_item_widget.dart';
import 'package:ecom/common/widgets/custom_drawer_widget.dart';
import 'package:ecom/common/widgets/flash_sale_widget.dart';
import 'package:ecom/common/widgets/heading_widget.dart';
import 'package:ecom/screens/user-panel/all_category_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../utils/constants/app_constraint.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

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
        centerTitle: true,
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

              HeadingWidget(headingTitle: 'Flash Sale', headingSubTitle: 'Low Price', onTap: () {  }, buttonText: 'See More >',),
              FlashSaleWidget(),
            ],
          ),
        ),
      ),

    );
  }
}
