import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom/models/product_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductImagesWidget extends StatelessWidget {
  ProductModel productModel;

  ProductImagesWidget({required this.productModel});

  @override
  Widget build(BuildContext context) {
    return  SizedBox(
        height: 70,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: productModel.productImages.length,
          itemBuilder: (context, index) {
            final image = productModel.productImages[index];
            return Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child:
                    Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            image: DecorationImage(image: NetworkImage(image),fit: BoxFit.cover)
                        )),

              );

          },
        ),
      );




  }
}
