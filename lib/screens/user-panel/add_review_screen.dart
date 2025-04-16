import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom/models/order_model.dart';
import 'package:ecom/models/review_model.dart';
import 'package:ecom/screens/user-panel/main_screen.dart';
import 'package:ecom/screens/user-panel/product_detail.dart';
import 'package:ecom/utils/constants/app_constraint.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

class AddReviewScreen extends StatefulWidget {
  final OrderModel orderModel;
   AddReviewScreen({required this.orderModel});

  @override
  State<AddReviewScreen> createState() => _AddReviewScreenState();
}

class _AddReviewScreenState extends State<AddReviewScreen> {
  final feedbackController=TextEditingController();

  double productRating=0.0;


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstant.appMainColor,
        title: Text('Add review',style: TextStyle(color: AppConstant.appTextColor),),
        iconTheme: IconThemeData(color: AppConstant.appTextColor),
      ),
      body: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            SizedBox(height: 50.0,),
            Text('Add Your rating and review'),
            SizedBox(height: 20.0,),
             RatingBar.builder(
                initialRating: 3,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, index) =>
                     Icon(Icons.star,color: Colors.amber,),
                  onRatingUpdate: (value) {
                    productRating=value;
                    setState(() {
                    });
                  },),

            SizedBox(height: 50.0,),

            TextFormField(
              maxLines: 3,
              controller: feedbackController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 5.0,vertical: 10.0),
                prefixIcon: Icon(Icons.feedback),
                label: Text('Share your feedback'),
                border: OutlineInputBorder()
              ),
            ),
            SizedBox(height: 20.0,),
             ElevatedButton(
               style: ElevatedButton.styleFrom(
                 backgroundColor: AppConstant.appMainColor
               ),
                 onPressed: ()async{
                 EasyLoading.show(status: 'Please wait..');
                 String feedback=feedbackController.text.trim();
                 ReviewModel reviewModel=ReviewModel(
                     customerName: widget.orderModel.customerName,
                     customerPhone: widget.orderModel.customerPhone,
                     customerDeviceToken: widget.orderModel.customerDeviceToken,
                     customerId: widget.orderModel.customerId,
                     feedback: feedback,
                     rating: productRating.toString(),
                     createdAt: DateTime.now());

                      if(feedbackController.text.isNotEmpty){
                       await FirebaseFirestore.instance.collection('products').doc(widget.orderModel.productId).
                        collection('review').doc(widget.orderModel.customerId).set(reviewModel.toMap());

                       EasyLoading.dismiss();
                       Get.snackbar('Success', 'Review sumitted successfully',snackPosition: SnackPosition.BOTTOM,backgroundColor: AppConstant.appMainColor);
                       Get.offAll(()=>MainScreen());
                      }else{
                        EasyLoading.dismiss();
                        Get.snackbar('Fill all details', 'Please write your review here');
                      }
              }, child: Text('Submit',style: TextStyle(color: AppConstant.appTextColor),)),

          ],
        ),
      ),
    );
  }
}
