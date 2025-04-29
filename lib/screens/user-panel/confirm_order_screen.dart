import 'package:ecom/common/widgets/custom_bottom_btn.dart';
import 'package:ecom/screens/user-panel/all_order_screen.dart';
import 'package:ecom/screens/user-panel/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConfirmOrderScreen extends StatelessWidget {
  const ConfirmOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.asset('assets/illustrator/confirm_order_illustrator.png',width: double.infinity,height: 400,),
         Column(
           children: [
             Text('Order Confirmed!',style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold,fontFamily: 'Inter'),),
             Text('Your order has been confirmed',style: TextStyle(color: Colors.grey,fontSize: 12,fontFamily: 'Inter'),),
           ],
         ),
          InkWell(
            onTap: (){
              Get.offAll(()=>AllOrderScreen());
            },
            child: Container(
              height: 50,
              margin: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(child: Text('Go to Orders',style: TextStyle(fontFamily: 'Inter'),),),
            ),
          )
        ],
      ),
      bottomSheet: CustomBottomBtn(title: 'Continue Shopping', callback: ()async{
        Get.offAll(()=>MainScreen());
      }),
    );
  }
}
