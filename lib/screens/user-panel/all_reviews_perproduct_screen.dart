import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom/models/product_model.dart';
import 'package:ecom/models/review_model.dart';
import 'package:ecom/utils/constants/app_constraint.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AllReviewsPerproductScreen extends StatelessWidget {
  ProductModel productModel;
  AllReviewsPerproductScreen({required this.productModel});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Text("Reviews",style: TextStyle(fontSize: 22,color: Colors.black,fontWeight: FontWeight.bold,fontFamily: 'Inter'),),
          StreamBuilder(
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
                      child:Expanded(
                        child: ListView.builder(
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

                            return  Container(
                                margin: EdgeInsets.symmetric(horizontal: 10.0,vertical: 10),
                                child: Column(
                                  children: [
                                    ListTile(
                                        leading: CircleAvatar(child: Center(child: Text(reviewModel.customerName.substring(0,1)),),),
                                        title: Text(reviewModel.customerName),
                                        subtitle:Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons.access_time_outlined,size: 18,color: Colors.grey,),
                                            SizedBox(width: 5,),
                                            Text('${DateFormat('dd MMM,yyyy').format(reviewModel.createdAt.toDate())}')

                                          ],
                                        ),
                                        trailing: Column(
                                          children: [
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(reviewModel.rating,style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                                                SizedBox(width: 5,),
                                                Text('rating',style: TextStyle(color: Colors.grey,fontSize: 12),),
                                              ],
                                            ),
                                            RatingBar(
                                              itemCount: 5,
                                                direction: Axis.horizontal,
                                                allowHalfRating: true,
                                                ignoreGestures: true,
                                                initialRating: double.parse(reviewModel.rating),
                                                itemSize: 10,
                                                itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                                                ratingWidget: RatingWidget(
                                                    full: Icon(Icons.star,color: Colors.amber,),
                                                    half: Icon(Icons.star_half,color: Colors.amber,),
                                                    empty: Icon(Icons.star_border,color: Colors.amber,)),
                                                onRatingUpdate: (value) {},)
                                          ],
                                        )
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Container(
                                            margin: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                            child: Text(reviewModel.feedback,style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold,fontSize: 12),)),
                                      ],
                                    )
                                  ],
                                )
                            );
                          },),
                      )

                  );
              }
              return Container();
            },),
        ],
      ),
    );
  }
}
