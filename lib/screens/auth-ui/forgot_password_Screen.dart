import 'package:ecom/contollers/forgot_password_controller.dart';
import 'package:flutter/material.dart';

import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:lottie/lottie.dart';
import 'package:get/get.dart';

import '../../utils/constants/app_constraint.dart';

class ForgotPasswordScreen extends StatefulWidget {


  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {

  final ForgotPasswordController forgotPasswordController=Get.put(ForgotPasswordController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
             Column(
               children: [
                 Text("Forgot Password",style: TextStyle(fontSize: 22,color: Colors.black,fontWeight: FontWeight.bold,fontFamily: 'Inter'),),
                 Image.asset('assets/icons/forgotpwd_illustator.png'),

                 Obx(()=>Container(
                     margin: EdgeInsets.symmetric(horizontal: 5.0),
                     width: Get.width,
                     child: Padding(
                       padding: const EdgeInsets.all(10.0),
                       child: TextFormField(
                         textInputAction: TextInputAction.next,
                         cursorColor: AppConstant.appSecondaryColor,
                         keyboardType: TextInputType.emailAddress,
                         decoration: InputDecoration(
                           hintText: 'Email',
                           prefixIcon: Icon(Icons.email),
                             errorText: forgotPasswordController.emailErrorText.value
                         ),onChanged: (value){
                         forgotPasswordController.emailController.value=value;
                         forgotPasswordController.validateEmailInput();
                       },
                       ),
                     )),)
               ],
             ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Please write your email to receive a',style: TextStyle(color: Colors.grey,fontSize: 12,fontFamily: 'Inter'),),
                  Text('confirmation code to set a new password',style: TextStyle(color: Colors.grey,fontSize: 12,fontFamily: 'Inter'),),
                ],
              )
            ],
          ),
        ),
      ),
      bottomSheet: InkWell(
        onTap: ()async{
          bool isEmailValid=forgotPasswordController.validateEmailInput();
          if(isEmailValid){
            final email=forgotPasswordController.emailController.value.trim();
              forgotPasswordController.ForgetPasswordMethod(email);
          }
         else{
            Get.snackbar("Validation Failed", "Fix Errors",snackPosition: SnackPosition.BOTTOM,colorText: AppConstant.appTextColor);
          }
        },
        child: Container(
          height: 60,
          width: double.infinity,
          color: AppConstant.appMainColor,
          child: Center(child: Text('Confirm Mail',style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.bold,fontFamily: 'Inter'),)),
        ),
      ),

    );

  }
}
