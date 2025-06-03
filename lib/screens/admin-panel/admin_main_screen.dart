import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom/models/product_model.dart';
import 'package:ecom/screens/admin-panel/add_category_screen.dart';
import 'package:ecom/screens/admin-panel/add_product_screen.dart';
import 'package:ecom/screens/admin-panel/admin_orders_screen.dart';
import 'package:ecom/utils/constants/app_constraint.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/widgets/custom_admin_drawer_widget.dart';
import '../../contollers/add_product_controller.dart';

class AdminMainScreen extends StatefulWidget {

  @override
  State<AdminMainScreen> createState() => _AdminMainScreenState();
}
class _AdminMainScreenState extends State<AdminMainScreen> {
  
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text('Admin Panel'),
      ),
      drawer: CustomAdminDrawerWidget(),
    body: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        InkWell(
          onTap: (){
            Get.to(()=>AdminOrdersScreen());
          },
          child: Card(
            child: Container(
              margin: EdgeInsets.only(top: 20,left: 5,right: 5),
              height: 150,
              width: MediaQuery.sizeOf(context).width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                  color: Colors.white
              ),
                child:
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: AppConstant.appSecondaryColor,
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(20),bottomLeft: Radius.circular(20))
                        ),
                        height: MediaQuery.of(context).size.height,
                        width: 10,

                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                alignment: Alignment.topLeft,
                                child: Text('All Orders',style: TextStyle(fontFamily: 'Inter',fontSize: 18,color: Colors.black))),
                            Container(
                                alignment: Alignment.topLeft,
                                child: Text("Tap here to see all Order's status",style: TextStyle(fontFamily: 'Inter',fontSize: 16,color: Colors.grey))),
                          ],
                        ),
                      ),
                    ],
                  )
            ),
          ),
        ),
        InkWell(
          onTap: (){
            Get.to(()=>AddCategoryScreen());
          },
          child: Card(
            child: Container(
                margin: EdgeInsets.only(top: 20,left: 5,right: 5),
                height: 150,
                width: MediaQuery.sizeOf(context).width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white
                ),
                child:
                Row(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height,
                      width: 10,
                      decoration: BoxDecoration(
                          color: AppConstant.appSecondaryColor,
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(20),bottomLeft: Radius.circular(20))
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              alignment: Alignment.topLeft,
                              child: Text('Add Category',style: TextStyle(fontFamily: 'Inter',fontSize: 18,color: Colors.black))),
                          Container(
                              alignment: Alignment.topLeft,
                              child: Text("Tap here to add Category",style: TextStyle(fontFamily: 'Inter',fontSize: 16,color: Colors.grey))),
                        ],
                      ),
                    ),
                  ],
                )
            ),
          ),
        ),
        InkWell(
          onTap: (){
            Get.to(()=>AddProductScreen());
          },
          child: Card(
            child: Container(
                margin: EdgeInsets.only(top: 20,left: 5,right: 5),
                height: 150,
                width: MediaQuery.sizeOf(context).width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white
                ),
                child:
                Row(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height,
                      width: 10,
                      decoration: BoxDecoration(
                          color: AppConstant.appSecondaryColor,
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(20),bottomLeft: Radius.circular(20))
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              alignment: Alignment.topLeft,
                              child: Text('Add Product',style: TextStyle(fontFamily: 'Inter',fontSize: 18,color: Colors.black))),
                          Container(
                              alignment: Alignment.topLeft,
                              child: Text("Tap here to see add Product",style: TextStyle(fontFamily: 'Inter',fontSize: 16,color: Colors.grey))),
                        ],
                      ),
                    ),
                  ],
                )
            ),
          ),
        ),
      ],
    )
    );
  }
}