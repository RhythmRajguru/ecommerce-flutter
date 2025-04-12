import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom/models/category_model.dart';
import 'package:ecom/screens/user-panel/single_category_product.dart';
import 'package:ecom/utils/constants/app_constraint.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_card/image_card.dart';

class AllCategoryScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstant.appMainColor,
        title: Text('All Categories',style: TextStyle(color: AppConstant.appTextColor),),
        iconTheme: IconThemeData(color: AppConstant.appTextColor),
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance.collection('categories').get(),
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
            return Center(child: Text('No Category found'),);
          }
          if(snapshot.data!=null){
            return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,mainAxisSpacing: 3,crossAxisSpacing: 3,childAspectRatio: 1.19),
              itemBuilder: (context, index) {
                CategoryModel categoryModel=CategoryModel(
                    categoryId: snapshot.data!.docs[index]['categoryId'],
                    categoryImg: snapshot.data!.docs[index]['categoryImg'],
                    categoryName: snapshot.data!.docs[index]['categoryName'],
                    createdAt: snapshot.data!.docs[index]['createdAt'],
                    updateAt: snapshot.data!.docs[index]['updatedAt']);
                return Row(
                    children: [
                Padding(padding: EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: (){
                    Get.to(SingleCategoryProduct(categoryId:categoryModel.categoryId,categoryName: categoryModel.categoryName,));
                  },
                  child: Container(
                  child: FillImageCard(
                  imageProvider: CachedNetworkImageProvider(categoryModel.categoryImg),
                  width: Get.width/2.3,
                  heightImage: Get.height/10,
                  borderRadius: 20.0,
                  title: Center(child: Text(categoryModel.categoryName,style: TextStyle(fontSize: 12.0,fontWeight: FontWeight.w800),)),
                  ),
                                ),
                ),),
                  ],
                );
              },itemCount: snapshot.data!.docs.length,shrinkWrap: true,
            );
          }
          return Container();
        },),
    );
  }
}
