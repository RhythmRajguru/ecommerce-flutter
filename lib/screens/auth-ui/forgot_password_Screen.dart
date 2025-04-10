import 'package:ecom/contollers/forgot_password_controller.dart';
import 'package:ecom/contollers/login_controller.dart';
import 'package:ecom/screens/auth-ui/login_screen.dart';
import 'package:ecom/screens/auth-ui/register_screen.dart';
import 'package:ecom/screens/user-panel/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  final emailController=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(builder: (p0, isKeyboardVisible) {
      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: AppConstant.appMainColor,
          title: Text('Sign In',
            style: TextStyle(color: AppConstant.appTextColor),),
        ),
        body: Container(
          child: Column(
            children: [
              isKeyboardVisible?SizedBox.shrink():
              Column(
                children: [
                  Container(height: Get.height/2.5,width: Get.width,color: AppConstant.appMainColor,child: Lottie.asset('assets/images/splash-icon.json',)),
                ],
              ),
              SizedBox(height: Get.height/30,),
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  width: Get.width,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      controller: emailController,
                      cursorColor: AppConstant.appSecondaryColor,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          hintText: 'Email',
                          contentPadding: EdgeInsets.only(top: 2.0,left: 8.0),
                          prefixIcon: Icon(Icons.email),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          )
                      ),
                    ),
                  )),
              SizedBox(height: Get.height/70,),

              Material(child: Container(
                width: Get.width/2,
                height: Get.height/18,
                decoration: BoxDecoration(
                  color: AppConstant.appSecondaryColor,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: TextButton(
                  child: Text('Submit',style: TextStyle(color: AppConstant.appTextColor),),
                  onPressed: ()async{
                    final email=emailController.text.trim();

                    if(email.isEmpty){
                      Get.snackbar("Error", "Please enter email",snackPosition: SnackPosition.BOTTOM,backgroundColor: AppConstant.appSecondaryColor,colorText: AppConstant.appTextColor);
                    }else{
                      forgotPasswordController.ForgetPasswordMethod(email);

                    }

                  },
                ),
              ),),
            ],
          ),
        ),);
    },);


  }
}
