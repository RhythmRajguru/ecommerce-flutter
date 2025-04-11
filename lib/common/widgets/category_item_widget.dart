import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom/models/category_model.dart';
import 'package:flutter/cupertino.dart';
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
          height: Get.height/5,
          child: ListView.builder(itemBuilder: (context, index) {
            CategoryModel categoryModel=CategoryModel(
                categoryId: snapshot.data!.docs[index]['categoryId'],
                categoryImg: snapshot.data!.docs[index]['categoryImg'],
                categoryName: snapshot.data!.docs[index]['categoryName'],
                createdAt: snapshot.data!.docs[index]['createdAt'],
                updateAt: snapshot.data!.docs[index]['updatedAt']);
            return Row(
              children: [
                Padding(padding: EdgeInsets.all(5.0),
                child: Container(
                  child: FillImageCard(
                    imageProvider: CachedNetworkImageProvider(categoryModel.categoryImg),
                  width: Get.width/4.0,
                  heightImage: Get.height/12,
                  borderRadius: 20.0,
                  title: Center(child: Text(categoryModel.categoryName,style: TextStyle(fontSize: 12.0,fontWeight: FontWeight.w800),)),
                  ),
                ),),
              ],
            );
          },itemCount: snapshot.data!.docs.length,shrinkWrap: true,scrollDirection: Axis.horizontal,),
        );
      }
      return Container();
    },);
  }
}
