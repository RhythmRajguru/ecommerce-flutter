import 'package:ecom/contollers/google_signin_controller.dart';
import 'package:ecom/screens/auth-ui/login_screen.dart';
import 'package:ecom/screens/auth-ui/register_screen.dart';
import 'package:flutter/material.dart';

import 'package:lottie/lottie.dart';
import 'package:get/get.dart';

import '../../utils/constants/app_constraint.dart';

class WelcomeScreen extends StatelessWidget {


  final GoogleSignInController _googleSignInController=Get.put(GoogleSignInController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppConstant.appMainColor,
        title: Text('Welcome to app',
        style: TextStyle(color: AppConstant.appTextColor),),
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              color: AppConstant.appMainColor,
              child: Lottie.asset('assets/images/splash-icon.json'),),
            Container(
              margin: EdgeInsets.only(top: 20.0),
              child: Text('Happy Shopping',style:
                TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold),),),
            SizedBox(height: Get.height/12,),
            Material(child: Container(
              width: Get.width/1.2,
              height: Get.height/12,
              decoration: BoxDecoration(
                color: AppConstant.appSecondaryColor,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: TextButton.icon(
                icon: Image.asset('assets/icons/google.png',width: Get.width/12,height: Get.height/12,),
                label: Text('Sign in with Google',style: TextStyle(color: AppConstant.appTextColor),),
                onPressed: (){
                  _googleSignInController.signInwithGoogle();
                },
              ),
            ),),
            SizedBox(height: Get.height/50,),
            Material(child: Container(
              width: Get.width/1.2,
              height: Get.height/12,
              decoration: BoxDecoration(
                color: AppConstant.appSecondaryColor,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: TextButton.icon(
                icon: Image.asset('assets/icons/email.png',color: Colors.white,width: Get.width/12,height: Get.height/12,),
                label: Text('Sign in with Email',style: TextStyle(color: AppConstant.appTextColor),),
                onPressed: (){
                  Get.to(LoginScreen());
                },
              ),
            ),),
          ],
        ),
      ),
    );
  }
}
