import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom/models/category_model.dart';
import 'package:ecom/screens/user-panel/all_category_screen.dart';
import 'package:ecom/screens/user-panel/single_category_product.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_card/image_card.dart';

class CategoryItemWidget extends StatelessWidget {
  const CategoryItemWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
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
        return Container(
          height: 190,
          child: ListView.builder(itemBuilder: (context, index) {
            CategoryModel categoryModel=CategoryModel(
                categoryId: snapshot.data!.docs[index]['categoryId'],
                categoryImg: snapshot.data!.docs[index]['categoryImg'],
                categoryName: snapshot.data!.docs[index]['categoryName'],
                createdAt: snapshot.data!.docs[index]['createdAt'],
                updateAt: snapshot.data!.docs[index]['updatedAt']);
            return InkWell(
              onTap: (){
                Get.to(()=>SingleCategoryProduct(categoryId: categoryModel.categoryId, categoryName: categoryModel.categoryName));
              },
              child:   Container(
                margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                child: Column(

                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        height: 130,
                        width: 150,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(image: NetworkImage(categoryModel.categoryImg),fit: BoxFit.cover)
                        )),
                    SizedBox(height: 5,),
                    Text(categoryModel.categoryName,style: TextStyle(fontSize: 14,fontFamily: 'Inter'),),


                  ],
                ),
              ),


            );
          },itemCount: snapshot.data!.docs.length,shrinkWrap: true,scrollDirection: Axis.horizontal,),
        );
      }
      return Container();
    },);
  }
}
