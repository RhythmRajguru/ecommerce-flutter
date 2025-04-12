import 'package:ecom/utils/constants/app_constraint.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstant.appMainColor,
        title: Text('Cart',style: TextStyle(color: AppConstant.appTextColor),),
        iconTheme: IconThemeData(color: AppConstant.appTextColor),
      ),
      body: Container(
        child:ListView.builder(
          itemCount: 20,
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, index) {
          return Card(
            color: AppConstant.appTextColor,
            elevation: 5,
            child: ListTile(
              leading: CircleAvatar(backgroundColor: AppConstant.appMainColor,child: Text('e'),),
              title: Text('eef'),
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('22'),
                 Row(
                   children: [
                     CircleAvatar(radius: 14.0,backgroundColor: AppConstant.appMainColor,child: Text('-'),),
                     SizedBox(width: 10,),
                     CircleAvatar(radius: 14.0,backgroundColor: AppConstant.appMainColor,child: Text('+'),),
                   ],
                 )
                ],
              ),
            ),
          );
        },)
        
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(bottom: 5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text('Sub Total'),
            ),
            SizedBox(width: Get.width/40,),
            Text('Rs.'+'12.00',style: TextStyle(fontWeight: FontWeight.bold),),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(child: Container(
                width: Get.width/2.0,
                height: Get.height/18,
                decoration: BoxDecoration(
                  color: AppConstant.appSecondaryColor,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: TextButton(
                  child: Text('Checkout',style: TextStyle(color: AppConstant.appTextColor),),
                  onPressed: (){

                  },
                ),
              ),),
            ),
          ],
        ),
      ),
    );
  }
}
