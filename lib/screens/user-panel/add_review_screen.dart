import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom/common/widgets/custom_bottom_btn.dart';
import 'package:ecom/contollers/feedback_controller.dart';
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
import 'package:image_card/image_card.dart';

class AddReviewScreen extends StatefulWidget {
  final OrderModel orderModel;

  AddReviewScreen({required this.orderModel});

  @override
  State<AddReviewScreen> createState() => _AddReviewScreenState();
}

class _AddReviewScreenState extends State<AddReviewScreen> {

  FeedbackController feedbackController=Get.put(FeedbackController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Add Review',style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Inter',fontSize: 20),),
      ),
      body: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [


             Container(
                 alignment: Alignment.centerLeft,
                 margin: EdgeInsets.only(top: 30),
                 child: Text('Name',style: TextStyle(fontFamily: 'Inter',fontWeight: FontWeight.w600,fontSize: 16),)),
         Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: TextFormField(
                initialValue: widget.orderModel.customerName,
                readOnly: true,
                decoration: InputDecoration(
                  filled: true,
                    fillColor: Colors.grey[250],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8), // optional: rounded corners
                      borderSide: BorderSide.none, // optional: remove border line
                    ),
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 10.0),
                    hintText: 'Type your name',
                ),

              ),
            ),
             Container(
               alignment: Alignment.centerLeft,
                 margin: EdgeInsets.only(top: 10),
                 child: Text('How was your experience ?',style: TextStyle(fontFamily: 'Inter',fontWeight: FontWeight.w600,fontSize: 16),)),
            Obx(()=> Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: TextFormField(
                maxLines: 3,
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[250],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8), // optional: rounded corners
                      borderSide: BorderSide.none,             // optional: remove border line
                    ),
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 10.0),
                    hintText: 'Share your feedback',
                    errorText: feedbackController.reviewErrorText.value

                ),

                onChanged: (value){
                  feedbackController.reviewController.value=value;
                  feedbackController.validateReviewInput();
                },
              ),
            )),
            Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(top: 10),
                child: Text('Star',style: TextStyle(fontFamily: 'Inter',fontWeight: FontWeight.w600,fontSize: 16),)),

           Row(
             children: [
               Text('0.0',style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Inter'),),
               Expanded(
                 child: Obx(()=>Slider(
                   value: feedbackController.currentValue.value,
                   min: 0,
                   max: 5,
                   divisions: 10,
                   label: feedbackController.currentValue.value.toString(),
                   onChanged: (value) {
                     feedbackController.currentValue.value = value;
                   },)),
               ),
               Text('5.0',style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Inter'),),
             ],
           ),

          ],
        ),
      ),
      bottomSheet: CustomBottomBtn(title: 'Submit Review', callback: ()async{
        bool isReviewValid=feedbackController.validateReviewInput();

        EasyLoading.show(status: 'Please wait..');

        ReviewModel reviewModel = ReviewModel(
            customerName: widget.orderModel.customerName,
            customerPhone: widget.orderModel.customerPhone,
            customerDeviceToken: widget.orderModel
                .customerDeviceToken,
            customerId: widget.orderModel.customerId,
            feedback: feedbackController.reviewController.value,
            rating: feedbackController.currentValue.value.toString(),
            createdAt: DateTime.now());

        if (isReviewValid) {
          await FirebaseFirestore.instance.collection('products').doc(
              widget.orderModel.productId).
          collection('review').doc(widget.orderModel.customerId).set(
              reviewModel.toMap());

          EasyLoading.dismiss();
          Get.snackbar('Success', 'Review submitted successfully',
            snackPosition: SnackPosition.BOTTOM,
          );
          Get.offAll(() => MainScreen());
        } else {
          EasyLoading.dismiss();
          Get.snackbar(
              'Fill all details', 'Please write your review here',snackPosition: SnackPosition.BOTTOM);
        }      }),
    );
  }
}
