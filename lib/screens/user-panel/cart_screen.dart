import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom/common/widgets/custom_bottom_btn.dart';
import 'package:ecom/contollers/cart_price_controller.dart';
import 'package:ecom/models/cart_model.dart';
import 'package:ecom/models/product_model.dart';
import 'package:ecom/screens/user-panel/checkout_screen.dart';
import 'package:ecom/screens/user-panel/product_detail.dart';
import 'package:ecom/utils/constants/app_constraint.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:get/get.dart';
import 'package:image_card/image_card.dart';

class CartScreen extends StatelessWidget {
  User? user = FirebaseAuth.instance.currentUser;

  final CartPriceController cartPriceController = Get.put(
    CartPriceController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Cart',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            StreamBuilder(
              stream:
                  FirebaseFirestore.instance
                      .collection('cart')
                      .doc(user!.uid)
                      .collection('cartOrders')
                      .snapshots(),
              builder: (
                BuildContext context,
                AsyncSnapshot<QuerySnapshot> snapshot,
              ) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    height: Get.height / 5,
                    child: Center(child: CupertinoActivityIndicator()),
                  );
                }
                if (snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No Products found'));
                }
                if (snapshot.data != null) {
                  return Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height - 260,
                        child: ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            final cartData = snapshot.data!.docs[index];

                            CartModel cartModel = CartModel(
                              productId: cartData['productId'],
                              categoryId: cartData['categoryId'],
                              productName: cartData['productName'],
                              categoryName: cartData['categoryName'],
                              salePrice: cartData['salePrice'],
                              fullPrice: cartData['fullPrice'],
                              productImages: cartData['productImages'],
                              deliveryTime: cartData['deliveryTime'],
                              isSale: cartData['isSale'],
                              size: cartData['size'],
                              productDescription:
                                  cartData['productDescription'],
                              createdAt: cartData['createdAt'],
                              updatedAt: cartData['updatedAt'],
                              productQuantity: cartData['productQuantity'],
                              productTotalPrice: cartData['productTotalPrice'],
                            );

                            //calculate price
                            cartPriceController.fetchProductPrice();

                            return SwipeActionCell(
                              key: ObjectKey(cartModel.productId),
                              trailingActions: [
                                SwipeAction(
                                  title: 'Delete',
                                  forceAlignmentToBoundary: true,
                                  performsFirstActionWithFullSwipe: true,
                                  onTap: (CompletionHandler handler) async {
                                    await FirebaseFirestore.instance
                                        .collection('cart')
                                        .doc(user!.uid)
                                        .collection('cartOrders')
                                        .doc(cartModel.productId)
                                        .delete();
                                  },
                                ),
                              ],
                              child: InkWell(
                                onTap: () {},
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Left Side - Image
                                      Container(
                                        height: 120,
                                        width: 100,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          image: DecorationImage(
                                            image: NetworkImage(cartModel.productImages[0]),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10),

                                      // Right Side - Text and Controls
                                      Expanded(
                                        child: Container(
                                          margin: EdgeInsets.symmetric(horizontal: 10,),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                cartModel.productName,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(height: 5),
                                              Text(
                                                '₹' + cartModel.productTotalPrice.toString(),
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontFamily: 'Inter',
                                                ),
                                              ),

                                              SizedBox(height: 30),
                                              Row(
                                                children: [
                                                  // Decrease button
                                                  InkWell(
                                                    onTap: () {
                                                      if (cartModel.productQuantity > 1) {
                                                        FirebaseFirestore.instance
                                                            .collection('cart')
                                                            .doc(user!.uid)
                                                            .collection('cartOrders')
                                                            .doc(cartModel.productId)
                                                            .update({
                                                          'productQuantity': cartModel.productQuantity - 1,
                                                          'productTotalPrice': cartModel.productTotalPrice -
                                                              double.parse(
                                                                cartModel.isSale
                                                                    ? cartModel.salePrice
                                                                    : cartModel.fullPrice,
                                                              ),
                                                        });
                                                      } else {
                                                        FirebaseFirestore.instance
                                                            .collection('cart')
                                                            .doc(user!.uid)
                                                            .collection('cartOrders')
                                                            .doc(cartModel.productId)
                                                            .delete();
                                                      }
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        border: Border.all(color: Colors.black, width: 0.5),
                                                      ),
                                                      child: CircleAvatar(
                                                        radius: 14,
                                                        backgroundColor: Colors.white,
                                                        child: Icon(Icons.arrow_drop_down, color: Colors.black),
                                                      ),
                                                    ),
                                                  ),

                                                  SizedBox(width: 10),

                                                  // Quantity text
                                                  Text(
                                                    cartModel.productQuantity.toString(),
                                                    style: TextStyle(
                                                      fontFamily: 'Inter',
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 16
                                                    ),
                                                  ),

                                                  SizedBox(width: 10),

                                                  // Increase button
                                                  InkWell(
                                                    onTap: () {
                                                      FirebaseFirestore.instance
                                                          .collection('cart')
                                                          .doc(user!.uid)
                                                          .collection('cartOrders')
                                                          .doc(cartModel.productId)
                                                          .update({
                                                        'productQuantity': cartModel.productQuantity + 1,
                                                        'productTotalPrice': cartModel.productTotalPrice +
                                                            double.parse(
                                                              cartModel.isSale
                                                                  ? cartModel.salePrice
                                                                  : cartModel.fullPrice,
                                                            ),
                                                      });
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        border: Border.all(color: Colors.black, width: 0.5),
                                                      ),
                                                      child: CircleAvatar(
                                                        radius: 14,
                                                        backgroundColor: Colors.white,
                                                        child: Icon(Icons.arrow_drop_up, color: Colors.black),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )

                            );
                          },
                        ),
                      ),
                    ],
                  );
                }
                return Container();
              },
            ),
            Container(
              color: Colors.white,
              width: double.infinity,
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(left: 20, bottom: 10, top: 5),
                    child: Text(
                      'Order Info',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 20),
                        child: Text(
                          'Subtotal',
                          style: TextStyle(
                            color: Colors.grey,
                            fontFamily: 'Inter',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Obx(
                        () => Container(
                          margin: EdgeInsets.only(right: 20),
                          child: Text(
                            "₹ " +
                                cartPriceController.totalPrice.value
                                    .toStringAsFixed(1),
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 20),
                        child: Text(
                          'Shipping cost',
                          style: TextStyle(
                            color: Colors.grey,
                            fontFamily: 'Inter',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 20),
                        child: Text(
                          "₹ " + "0",
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 20),
                        child: Text(
                          'Total',
                          style: TextStyle(
                            color: Colors.grey,
                            fontFamily: 'Inter',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Obx(
                        () => Container(
                          margin: EdgeInsets.only(right: 20),
                          child: Text(
                            "₹ " +
                                cartPriceController.totalPrice.value
                                    .toStringAsFixed(1),
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),

      bottomSheet: CustomBottomBtn(
        title: 'Checkout',
        callback: () {
          Get.to(() => CheckoutScreen());
        },
      ),
    );
  }
}
