import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom/common/widgets/custom_bottom_btn.dart';
import 'package:ecom/contollers/cart_price_controller.dart';
import 'package:ecom/contollers/order_controller.dart';
import 'package:ecom/models/cart_model.dart';
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

  Razorpay _razorpay=Razorpay();

  OrderController orderController=Get.put(OrderController());

  @override
  Widget build(BuildContext context) {

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

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
                      height: MediaQuery.of(context).size.height - 330,
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
        showCustomBottomSheet(context);
        GetServerKey getServerKey=GetServerKey();
        String accessToken=await getServerKey.getServerKeyToken();
      })
    );
  }

  void showCustomBottomSheet(BuildContext context) {
    Get.bottomSheet(
      Container(height: 435,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10,),
              Container(
                width: 100,
                  child: Divider(height: 7,color: Colors.grey,thickness: 4,)),
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 10.0),
                child: Obx(()=>TextFormField(
                    maxLines: 1,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                      hintStyle: TextStyle(fontSize: 12),
                      errorText: orderController.usernameErrorText.value
                    ),
                  onChanged: (value) {
                    orderController.usernameController.value=value;
                    orderController.validateUsernameInput();
                  },
                  )),

              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0,),
                child: Obx(()=> TextFormField(
                  maxLines: 1,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                    hintStyle: TextStyle(fontSize: 12),
                      errorText: orderController.emailErrorText.value
                  ),
                  onChanged: (value){
                    orderController.emailController.value=value;
                    orderController.validateEmailInput();
                  },
                )),

              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 10.0),
                child: Obx(()=> TextFormField(
                    maxLines: 1,
                    maxLength: 10,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: 'Phone',
                      contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                      hintStyle: TextStyle(fontSize: 12),
                        errorText: orderController.phoneErrorText.value
                    ),
                  onChanged: (value){
                    orderController.phoneController.value=value;
                    orderController.validatePhoneInput();
                  },
                  )),

              ),
              Padding(
                padding: const EdgeInsets.only(top: 0,left: 20,right: 20,bottom: 20),
                child:Obx(()=> TextFormField(
                    maxLines: 3,
                    keyboardType: TextInputType.streetAddress,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: 'Address',
                      contentPadding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 10.0),
                      hintStyle: TextStyle(fontSize: 12),
                        errorText: orderController.addressErrorText.value
                    ),
                  onChanged: (value){
                    orderController.addressController.value=value;
                    orderController.validateAddressInput();
                  },
                  )),

              ),
            InkWell(
                  onTap: ()async{
                    bool isUsernameValid=orderController.validateUsernameInput();
                    bool isEmailValid=orderController.validateEmailInput();
                    bool isPhoneValid=orderController.validatePhoneInput();
                    bool isAddressValid=orderController.validateAddressInput();


                      if(isUsernameValid && isEmailValid && isPhoneValid && isAddressValid){
                        String customerToken=await getCustomerDeviceToken();

                        var options={
                          'key':AppConstant.Razorpay_API_Key,
                          'amount':(cartPriceController.totalPrice.value * 100).toInt(),
                          'currency':'INR',
                          'name':orderController.usernameController.value.toString(),
                          'description':'E-commerce app payment',
                          'prefill':{
                            'contact':orderController.phoneController.value.toString(),
                            'email':orderController.emailController.value.toString()
                          }
                        };

                        _razorpay.open(options);
                      }
                      else{
                        Get.snackbar("Validation Failed", "Fix Errors",snackPosition: SnackPosition.BOTTOM,colorText: Colors.black);
                      }


                  },
                  child: Container(
                    margin: EdgeInsets.only(top:10),
                    height: 60,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppConstant.appMainColor,
                    ),
                    child: Center(child: Text('Place Order',style: TextStyle(color: Colors.white),)),
                  ),
                ),

            ],
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
      elevation: 6,
      shape: RoundedRectangleBorder()
    );
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response)async{

    String customerToken=await getCustomerDeviceToken();
    placeOrder(
      context:context,
      customerName:orderController.usernameController.value.toString(),
      customerPhone:orderController.phoneController.value.toString(),
      customerAddress:orderController.addressController.value.toString(),
      customerDeviceToken:customerToken,
    );
  }

  void _handlePaymentError(PaymentFailureResponse response){

  }

  void _handleExternalWallet(ExternalWalletResponse response){

  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _razorpay.clear();
  }
}
