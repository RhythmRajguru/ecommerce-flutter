import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom/common/widgets/address_widget.dart';
import 'package:ecom/common/widgets/custom_bottom_btn.dart';
import 'package:ecom/contollers/cart_price_controller.dart';
import 'package:ecom/contollers/order_controller.dart';
import 'package:ecom/models/cart_model.dart';
import 'package:ecom/screens/user-panel/confirm_order_detail.dart';
import 'package:ecom/services/get_server_key.dart';
import 'package:ecom/utils/constants/app_constraint.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../contollers/cutomer_devicetoken_controller.dart';
import '../../services/placeorder_service.dart';

class CheckoutScreen extends StatefulWidget {

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  User? user=FirebaseAuth.instance.currentUser;

  final CartPriceController cartPriceController=Get.put(CartPriceController());

  @override
  Widget build(BuildContext context) {



    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(

        title: Text('Checkout',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20),),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('cart').doc(user!.uid).collection('cartOrders').snapshots(),
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
            return Center(child: Text('No Products found'),);
          }
          if(snapshot.data!=null){
            return
              Column(
                children: [
                  Container(
                      height: MediaQuery.of(context).size.height - 430,
                      child:ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          final cartData=snapshot.data!.docs[index];

                          CartModel cartModel=CartModel(
                              productId: cartData['productId'],
                              categoryId: cartData['categoryId'],
                              productName: cartData['productName'],
                              categoryName: cartData['categoryName'],
                              salePrice: cartData['salePrice'],
                              fullPrice: cartData['fullPrice'],
                              productImages: cartData['productImages'],
                              deliveryTime: cartData['deliveryTime'],
                              isSale: cartData['isSale'],
                              productDescription: cartData['productDescription'],
                              createdAt: cartData['createdAt'],
                              updatedAt: cartData['updatedAt'],
                              productQuantity: cartData['productQuantity'],
                              productTotalPrice: cartData['productTotalPrice']);

                          //calculate price
                          cartPriceController.fetchProductPrice();

                          return SwipeActionCell
                            (key: ObjectKey(cartModel.productId),
                            trailingActions: [
                              SwipeAction(
                                  title: 'Delete',
                                  forceAlignmentToBoundary: true,
                                  performsFirstActionWithFullSwipe: true,
                                  onTap: (CompletionHandler handler)async{
                                    await FirebaseFirestore.instance.collection('cart').doc(user!.uid).collection('cartOrders').doc(cartModel.productId).delete();
                                  })
                            ],
                            child: Card(
                              color: Colors.white,
                              elevation: 5,
                              child:
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: SizedBox(
                                      height: 140,
                                      width: 100,
                                      child: Image.network(cartModel.productImages[0],fit: BoxFit.cover,),
                                    ),
                                    margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                                  ),
                                  Expanded(
                                    child: Container(
                                      margin: EdgeInsets.symmetric(horizontal: 10),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: 20,),
                                          Text(cartModel.productName,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,fontFamily: 'Inter'),),
                                          SizedBox(height: 10,),
                                          Text("₹ "+cartModel.productTotalPrice.toString(),style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,fontFamily: 'Inter',color: Colors.grey)),
                                          SizedBox(height: 10,),
                                          Text(cartModel.productDescription,maxLines: 3,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 14,fontFamily: 'Inter',color: Colors.grey),),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),



                            ),);
                        },)

                  ),
                  SizedBox(height: 5,),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Delivery Address',style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Inter',fontSize: 16),),
                        Icon(Icons.arrow_forward_ios,size: 20,)
                      ],
                    ),
                  ),
                  AddressWidget(),
                  SizedBox(height: 5,),
                  Column(
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Payment Method',style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Inter',fontSize: 16),),
                            Icon(Icons.arrow_forward_ios,size: 20,)
                          ],
                        ),
                      ),
                      ListTile(
                        leading: Image.asset('assets/icons/razorpay_icon.png'),
                        title: Text('Razorpay'),
                        subtitle: Text('Credit/Debit Card, UPI, Net Banking..'),
                        trailing: Icon(Icons.check_box,color: Colors.green,),
                      )
                    ],
                  ),

                  Column(
                    children: [
                      Container(
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.only(left: 20,bottom: 10,top: 5),
                          child: Text('Order Info',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,fontFamily: 'Inter'),)),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              margin: EdgeInsets.only(left: 20),
                              child: Text('Total',style: TextStyle(color: Colors.grey,fontFamily: 'Inter',fontSize: 14,fontWeight: FontWeight.bold),)),
                          Obx(()=>Container(
                              margin: EdgeInsets.only(right: 20),
                              child: Text("₹ "+cartPriceController.totalPrice.value.toStringAsFixed(1),style: TextStyle(fontFamily: 'Inter',fontSize: 14,fontWeight: FontWeight.bold),)),)
                        ],
                      ),
                      SizedBox(height: 10,),
                    ],
                  ),
                ],
              );
          }
          return Container();
        },),

      bottomSheet: CustomBottomBtn(title: 'Confirm Order', callback: ()async{

        Get.to(()=>ConfirmOrderDetail());
      })
    );
  }

  }


