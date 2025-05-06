import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom/models/product_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductSizeWidget extends StatefulWidget {
  ProductModel productModel;

  final List<dynamic> sizes;
  final void Function(String selectedSize) onSelected;

  ProductSizeWidget({required this.productModel,required this.sizes, required this.onSelected});

  @override
  State<ProductSizeWidget> createState() => _ProductSizeWidgetState();
}

class _ProductSizeWidgetState extends State<ProductSizeWidget> {

  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SizedBox(
        height: 50,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: widget.productModel.sizes.length,
          itemBuilder: (context, index) {
            final size = widget.productModel.sizes[index];
            final isSelected = index == selectedIndex;

    return GestureDetector(
          onTap: () {
            setState(() {
               selectedIndex = index;
                 });
              widget.onSelected(size); // return selected size
              },
              child: Container(
                 margin: EdgeInsets.symmetric(horizontal: 5),
                  height: 40,
                  width: 50,
                  decoration: BoxDecoration(
                  color: isSelected ? Colors.black : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                  color: isSelected ? Colors.black : Colors.transparent,
                  width: 1.5,
                      ),
                      ),
                  child: Center(
                  child: Text(
                  size.toString().isNotEmpty ? size : 'No',
                  style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Inter',
                  fontSize: 14,
                    ),
                  overflow: TextOverflow.ellipsis,
                      ),
                      ),
                      ),
                      );
                      },
                      ),
                      ));
  }
}
