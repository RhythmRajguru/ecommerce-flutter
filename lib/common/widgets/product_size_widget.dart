import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom/models/product_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductSizeWidget extends StatelessWidget {
  ProductModel productModel;

  ProductSizeWidget({required this.productModel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SizedBox(
        height: 60,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: productModel.sizes.length,
          itemBuilder: (context, index) {
            final size = productModel.sizes[index];
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 10), // space between items
              height: 50,
              width: 70,
              padding: EdgeInsets.symmetric(horizontal: 16), // make width dynamic
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  size,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );



  }
}
