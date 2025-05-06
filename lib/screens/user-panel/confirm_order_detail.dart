import 'package:ecom/common/widgets/custom_bottom_btn.dart';
import 'package:ecom/contollers/cart_price_controller.dart';
import 'package:ecom/contollers/cutomer_devicetoken_controller.dart';
import 'package:ecom/contollers/order_controller.dart';
import 'package:ecom/services/get_server_key.dart';
import 'package:ecom/services/placeorder_service.dart';
import 'package:ecom/utils/constants/app_constraint.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class ConfirmOrderDetail extends StatefulWidget {

  @override
  State<ConfirmOrderDetail> createState() => _ConfirmOrderDetailState();
}

class _ConfirmOrderDetailState extends State<ConfirmOrderDetail> {
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
      appBar: AppBar(
        centerTitle: true,
        title: Text('Customer Details',style: TextStyle(fontWeight: FontWeight.w600,fontFamily: 'Inter',fontSize: 20),),
      ),
      body:  Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
            Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.symmetric(horizontal: 30),
                child: Text('Name',style: TextStyle(fontFamily: 'Inter',fontWeight: FontWeight.w600,fontSize: 16),)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 10.0),
                child: Obx(()=>TextFormField(
                  maxLines: 1,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                      hintText: 'Enter your Name',
                      contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                      fillColor: Colors.grey[250],
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none
                      ),
                      errorText: orderController.usernameErrorText.value
                  ),
                  onChanged: (value) {
                    orderController.usernameController.value=value;
                    orderController.validateUsernameInput();
                  },
                )),

              ),
              Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.symmetric(horizontal: 30),
                  child: Text('Email',style: TextStyle(fontFamily: 'Inter',fontWeight: FontWeight.w600,fontSize: 16),)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 10),
                child: Obx(()=> TextFormField(
                  maxLines: 1,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                      hintText: 'Enter your Email',
                      contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                      errorText: orderController.emailErrorText.value,
                    fillColor: Colors.grey[250],
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none
                    ),
                  ),
                  onChanged: (value){
                    orderController.emailController.value=value;
                    orderController.validateEmailInput();
                  },
                )),

              ),

// Country and State Fields Row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Country Field
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Country', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w600, fontSize: 16)),
                          SizedBox(height: 8),
                          Obx(() => TextFormField(
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              hintText: 'Enter Country',
                              contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                              fillColor: Colors.grey[250],
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide.none,
                              ),
                              errorText: orderController.countryErrorText.value,
                            ),
                            onChanged: (value) {
                              orderController.countryController.value = value;
                              orderController.validateCountryInput();
                            },
                          )),
                        ],
                      ),
                    ),
                    SizedBox(width: 10),
                    // State Field
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('State', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w600, fontSize: 16)),
                          SizedBox(height: 8),
                          Obx(() => TextFormField(
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              hintText: 'Enter State',
                              contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                              fillColor: Colors.grey[250],
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide.none,
                              ),
                              errorText: orderController.stateErrorText.value,
                            ),
                            onChanged: (value) {
                              orderController.stateController.value = value;
                              orderController.validateStateInput();
                            },
                          )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),


              Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.symmetric(horizontal: 30),
                  child: Text('Phone Number',style: TextStyle(fontFamily: 'Inter',fontWeight: FontWeight.w600,fontSize: 16),)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 10.0),
                child: Obx(()=> TextFormField(
                  maxLines: 1,
                  maxLength: 10,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                      hintText: 'Enter your Phone No',
                      contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                      errorText: orderController.phoneErrorText.value,
                    fillColor: Colors.grey[250],
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none
                    ),
                  ),
                  onChanged: (value){
                    orderController.phoneController.value=value;
                    orderController.validatePhoneInput();
                  },
                )),
              ),
              Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.symmetric(horizontal: 30),
                  child: Text('Address',style: TextStyle(fontFamily: 'Inter',fontWeight: FontWeight.w600,fontSize: 16),)),
              Padding(
                padding: const EdgeInsets.only(top: 10,left: 20,right: 20,bottom: 20),
                child:Obx(()=> TextFormField(
                  keyboardType: TextInputType.streetAddress,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                      hintText: 'Enter your Address',
                      contentPadding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 10.0),
                      errorText: orderController.addressErrorText.value,
                    fillColor: Colors.grey[250],
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none
                    ),
                  ),
                  onChanged: (value){
                    orderController.addressController.value=value;
                    orderController.validateAddressInput();
                  },
                )),

              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: Text('Save as primary address',style: TextStyle(fontFamily: 'Inter',fontWeight: FontWeight.w600,fontSize: 16),)),
                Obx(()=>Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: CupertinoSwitch(value: orderController.saveAddress.value, onChanged: (value) {
                      orderController.saveAddress.value=value;
                  },),
                ))
                ],
              )
            ],
          ),
        ),
      ),
      bottomSheet: CustomBottomBtn(title: 'Place Order', callback: ()async{
        bool isUsernameValid=orderController.validateUsernameInput();
        bool isEmailValid=orderController.validateEmailInput();
        bool isStateValid=orderController.validateStateInput();
        bool isCountryValid=orderController.validateCountryInput();
        bool isPhoneValid=orderController.validatePhoneInput();
        bool isAddressValid=orderController.validateAddressInput();


        if(isUsernameValid && isEmailValid && isStateValid && isCountryValid && isPhoneValid && isAddressValid){
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
         GetServerKey getServerKey=GetServerKey();
         String accessToken=await getServerKey.getServerKeyToken();
      }),
    );
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response)async{

    String customerToken=await getCustomerDeviceToken();
    placeOrder(
      context:context,
      customerName:orderController.usernameController.value.toString(),
      customerPhone:orderController.phoneController.value.toString(),
      customerAddress:orderController.addressController.value.toString()+' '+orderController.stateController.value.toString()+' '+orderController.countryController.value.toString(),
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
