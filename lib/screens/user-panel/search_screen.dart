import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom/models/product_model.dart';
import 'package:ecom/screens/user-panel/product_detail.dart';
import 'package:ecom/utils/constants/app_constraint.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class SearchScreen extends StatefulWidget {

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final searchController=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    body: Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 40,left: 10,right: 10),
          child: TextField(
        onChanged: (value) {
          setState(() {

          });
        },
          textInputAction: TextInputAction.search,
          controller: searchController,
          decoration: InputDecoration(
              hintText: 'Search products here',
              contentPadding: EdgeInsets.all(10.0),
              prefixIcon: Icon(Icons.search,color: Colors.black,),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0)
              )
          ),
                ),
        ),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('products').snapshots(),
          builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot) {
            if(snapshot.connectionState==ConnectionState.waiting){
              return CircularProgressIndicator();
            }
            if(snapshot.hasError){
              return Text('Some Error');
            }
            return Expanded(
              child: ListView(
                children: snapshot.data!.docs.where((doc) {
                  final name = doc['productName'].toString().toLowerCase();

                  final query = searchController.text.toLowerCase();
                  return name.contains(query);
                }).map((doc) {
                  ProductModel productModel=ProductModel(
                      productId: doc['productId'],
                      categoryId: doc['categoryId'],
                      productName: doc['productName'],
                      categoryName: doc['categoryName'],
                      salePrice: doc['salePrice'],
                      fullPrice: doc['fullPrice'],
                      productImages: doc['productImages'],
                      deliveryTime: doc['deliveryTime'],
                      isSale: doc['isSale'],
                      productDescription: doc['productDescription'],
                      createdAt: doc['createdAt'],
                      updatedAt: doc['updatedAt']);
                  return InkWell(
                    onTap: (){
                      Get.to(ProductDetail(productModel: productModel));
                    },
                    child: ListTile(
                      leading: CircleAvatar(backgroundImage: NetworkImage(productModel.productImages[0]),),
                      title: Text(productModel.productName),
                      subtitle:
                          productModel.isSale
                          ?Row(
                            children: [
                          Text(productModel.salePrice),
                              SizedBox(width: 10,),
                          Text(productModel.fullPrice,style: TextStyle(decoration: TextDecoration.lineThrough,color: AppConstant.appMainColor))
                            ]
                          )
                          :Text(productModel.fullPrice,),

                    ),
                  );
                }).toList(),
    ),
            );
          },),
      ],
    )
    );
  }
}
