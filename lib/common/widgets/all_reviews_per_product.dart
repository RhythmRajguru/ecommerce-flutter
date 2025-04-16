import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom/models/product_model.dart';
import 'package:ecom/models/review_model.dart';
import 'package:ecom/utils/constants/app_constraint.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllReviewsPerProduct extends StatelessWidget {
  ProductModel productModel;
  AllReviewsPerProduct({required this.productModel});

  @override
  Widget build(BuildContext context) {
    return  StreamBuilder(
      stream: FirebaseFirestore.instance.collection('products').doc(productModel.productId).collection('review').snapshots(),
      builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot) {
        if(snapshot.hasError){
          return Center(child: Text('Error'),);
        }
        if(snapshot.connectionState==ConnectionState.waiting){
          return Container(
            height: Get.height/5,
            child: Center(child: CupertinoActivityIndicator(),),
          );
        }
        if(snapshot.data!.docs.isEmpty){
          return Center(child: Text('No Reviews found'),);
        }
        if(snapshot.data!=null){
          return
            Container(
                child:ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    final reviewData=snapshot.data!.docs[index];

                    ReviewModel reviewModel=ReviewModel(
                        customerName: reviewData['customerName'],
                        customerPhone: reviewData['customerPhone'],
                        customerDeviceToken: reviewData['customerDeviceToken'],
                        customerId: reviewData['customerId'],
                        feedback: reviewData['feedback'],
                        rating: reviewData['rating'],
                        createdAt: reviewData['createdAt']);


                    return  Card(
                      margin: EdgeInsets.symmetric(horizontal: 10.0),
                      color: AppConstant.appTextColor,
                      elevation: 5,
                      child: ListTile(
                          leading: CircleAvatar(child: Center(child: Text(reviewModel.customerName[0]),),),
                          title: Text(reviewModel.customerName),
                          subtitle: Text(reviewModel.feedback),
                          trailing:Text(reviewModel.rating)

                      ),
                    );
                  },)

            );
        }
        return Container();
      },);
  }
}
